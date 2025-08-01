import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/di/injection_container.dart';
import 'package:prism/features/account/presentation/bloc/account/groups_bloc/groups_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/join_group_bloc/join_group_bloc.dart';
import 'package:prism/features/account/presentation/widgets/simplified_group_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExploreGroupsPage extends StatefulWidget {
  const ExploreGroupsPage({super.key});

  @override
  State<ExploreGroupsPage> createState() => _ExploreGroupsPageState();
}

class _ExploreGroupsPageState extends State<ExploreGroupsPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _initializeGroups();
    _setupScrollListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeGroups() {
    context.read<GroupsBloc>().add(ExploreGroupsEvent(page: _currentPage));
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_shouldLoadMore()) {
        _loadMoreGroups();
      }
    });
  }

  bool _shouldLoadMore() {
    if (_isLoadingMore) return false;
    if (_scrollController.position.pixels <
        _scrollController.position.maxScrollExtent * 0.9) {
      return false;
    }

    final state = context.read<GroupsBloc>().state;
    if (state is! GroupsLoaded) return false;

    final pagination = state.paginatedGroups.pagination;
    return pagination != null &&
        state.paginatedGroups.pagination!.currentPage <
            state.paginatedGroups.pagination!.lastPage;
  }

  void _loadMoreGroups() {
    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });
    context.read<GroupsBloc>().add(ExploreGroupsEvent(page: _currentPage));
  }

  void _handleStateChange(BuildContext context, GroupsState state) {
    if (state is ExploreGroupsSuccess) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Widget _buildContent(BuildContext context, GroupsState state) {
    if (state is GroupsLoading && _currentPage == 1) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is GroupsFailure) {
      return Center(child: Text(state.message));
    }
    if (state is GroupsLoaded) {
      return _buildGroupsList(context, state);
    }
    return Center(
      child: Text(AppLocalizations.of(context)!.somethingWentWrong),
    );
  }

  Widget _buildGroupsList(BuildContext context, GroupsLoaded state) {
    final groups = state.paginatedGroups.groups;
    if (groups.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noGroupsFound));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: groups.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == groups.length && _isLoadingMore) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildGroupItem(context, groups[index]);
        },
      ),
    );
  }

  Widget _buildGroupItem(BuildContext context, dynamic group) {
    return BlocProvider(
      create: (context) => sl<JoinGroupBloc>(),
      child: SimplifiedGroupWidget(
        group: group,
        applyJoin: true,
        trigger: (context) {
          context.read<GroupsBloc>().add(
            ExploreGroupsEvent(page: _currentPage),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupsBloc, GroupsState>(
      listener: _handleStateChange,
      builder: _buildContent,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/di/injection_container.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/features/account/presentation/bloc/account/groups_bloc/groups_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/join_group_bloc/join_group_bloc.dart';
import 'package:prism/features/account/presentation/widgets/simplified_group_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupsPage extends StatefulWidget {
  final bool applyJoin;
  final Function(BuildContext context) trigger;
  final String title;

  const GroupsPage({
    super.key,
    required this.trigger,
    required this.title,
    required this.applyJoin,
  });

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    widget.trigger(context);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.9 &&
          !_isLoadingMore) {
        final state = context.read<GroupsBloc>().state;
        if (state is GroupsLoaded &&
            state.paginatedGroups.pagination != null &&
            state.paginatedGroups.pagination!.currentPage <
                state.paginatedGroups.pagination!.lastPage) {
          setState(() {
            _isLoadingMore = true;
            _currentPage++;
          });
          final isFollowedGroups = widget.title.toLowerCase().contains(
            'followed',
          );
          context.read<GroupsBloc>().add(
            isFollowedGroups
                ? GetFollowedGroupsEvent(page: _currentPage)
                : GetOwnedGroupsEvent(page: _currentPage),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: BlocListener<GroupsBloc, GroupsState>(
        listener: (context, state) {
          if (state is GroupsLoaded) {
            setState(() {
              _isLoadingMore = false;
            });
          }
        },

        child: BlocBuilder<GroupsBloc, GroupsState>(
          builder: (context, state) {
            if (state is GroupsLoading && _currentPage == 1) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GroupsFailure) {
              return Center(child: Text(state.message));
            } else if (state is GroupsLoaded) {
              final groups = state.paginatedGroups.groups;
              if (groups.isEmpty) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.noGroupsFound),
                );
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount: groups.length + (_isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == groups.length && _isLoadingMore) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final group = groups[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.groupPage,
                        arguments: {'groupId': group.id},
                      );
                    },
                    child: BlocProvider<JoinGroupBloc>(
                      create: (context) => sl<JoinGroupBloc>(),
                      child: SimplifiedGroupWidget(
                        group: group,
                        applyJoin: widget.applyJoin,
                        trigger: widget.trigger,
                      ),
                    ),
                  );
                },
              );
            }
            return Center(
              child: Text(AppLocalizations.of(context)!.somethingWentWrong),
            );
          },
        ),
      ),
    );
  }
}

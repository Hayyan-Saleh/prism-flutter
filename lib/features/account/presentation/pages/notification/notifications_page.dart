import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/localization/l10n/app_localizations.dart';
import 'package:prism/core/di/injection_container.dart';
import 'package:prism/features/account/domain/enitities/notification/follow_request_entity.dart';
import 'package:prism/features/account/domain/enitities/notification/join_request_entity.dart';
import 'package:prism/features/account/presentation/bloc/notification/notification_bloc/notification_bloc.dart';
import 'package:prism/features/account/presentation/widgets/follow_request_list_tile.dart';
import 'package:prism/features/account/presentation/widgets/join_request_list_tile.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationBloc>(
      create: (context) => sl<NotificationBloc>()..add(GetAllNotificationsEvent()),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    final local = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).colorScheme.secondary,
            automaticIndicatorColorAdjustment: true,
            dividerColor: Colors.transparent,
            indicatorColor: Theme.of(context).colorScheme.secondary,
            tabs: [
              Tab(text: local.all),
              Tab(text: local.requests),
              Tab(text: local.groupRequests),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildAllNotificationsView(),
                _buildFollowRequestsView(),
                _buildGroupRequestsView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllNotificationsView() {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        final local = AppLocalizations.of(context)!;
        if (state is NotificationLoaded) {
          final allNotifications = [
            ...state.followRequests,
            ...state.joinRequests
          ];
          if (allNotifications.isEmpty) {
            return Center(child: Text(local.noNewRequests));
          }
          // Ideally, sort by date if available
          return RefreshIndicator(
            onRefresh: () async {
              context.read<NotificationBloc>().add(GetAllNotificationsEvent());
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: allNotifications.length,
              itemBuilder: (context, index) {
                final item = allNotifications[index];
                if (item is FollowRequestEntity) {
                  return FollowRequestListTile(followRequest: item);
                }
                if (item is JoinRequestEntity) {
                  return JoinRequestListTile(joinRequest: item);
                }
                return const SizedBox.shrink();
              },
            ),
          );
        }
        if (state is NotificationError) {
          return Center(child: Text('${local.error}: ${state.message}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildFollowRequestsView() {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        final local = AppLocalizations.of(context)!;
        if (state is NotificationLoaded) {
          if (state.followRequests.isEmpty) {
            return Center(child: Text(local.noNewRequests));
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<NotificationBloc>().add(GetFollowRequestsEvent());
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.followRequests.length,
              itemBuilder: (context, index) {
                final request = state.followRequests[index];
                return FollowRequestListTile(followRequest: request);
              },
            ),
          );
        }
        if (state is NotificationError) {
          return Center(child: Text('${local.error}: ${state.message}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildGroupRequestsView() {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        final local = AppLocalizations.of(context)!;
        if (state is NotificationLoaded) {
          if (state.joinRequests.isEmpty) {
            return Center(child: Text(local.noNewRequests));
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<NotificationBloc>().add(GetJoinRequestsEvent());
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.joinRequests.length,
              itemBuilder: (context, index) {
                final request = state.joinRequests[index];
                return JoinRequestListTile(joinRequest: request);
              },
            ),
          );
        }
        if (state is NotificationError) {
          return Center(child: Text('${local.error}: ${state.message}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
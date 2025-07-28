import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prism/core/di/injection_container.dart';
import 'package:prism/features/account/presentation/bloc/notification/notification_bloc/notification_bloc.dart';
import 'package:prism/features/account/presentation/widgets/follow_request_list_tile.dart';
import 'package:prism/features/account/presentation/widgets/join_request_list_tile.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                Center(child: Text(local.all)),
                BlocProvider<NotificationBloc>(
                  create:
                      (context) =>
                          sl<NotificationBloc>()..add(GetFollowRequestsEvent()),
                  child: _buildFollowRequestsView(),
                ),

                BlocProvider<NotificationBloc>(
                  create:
                      (context) =>
                          sl<NotificationBloc>()..add(GetJoinRequestsEvent()),
                  child: _buildGroupRequestsView(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowRequestsView() {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {
        final local = AppLocalizations.of(context)!;
        if (state is NotificationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is FollowRequestResponseSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(local.requestHandledSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
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
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {
        final local = AppLocalizations.of(context)!;
        if (state is NotificationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is JoinRequestResponseSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(local.requestHandledSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        final local = AppLocalizations.of(context)!;
        if (state is JoinRequestsLoaded) {
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

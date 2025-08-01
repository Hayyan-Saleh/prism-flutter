import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prism/core/di/injection_container.dart';
import 'package:prism/features/account/presentation/bloc/account/group_bloc/group_bloc.dart';
import 'package:prism/features/account/presentation/bloc/notification/notification_bloc/notification_bloc.dart';
import 'package:prism/features/account/presentation/widgets/join_request_list_tile.dart';

class GroupJoinRequestsPage extends StatefulWidget {
  final int groupId;
  const GroupJoinRequestsPage({super.key, required this.groupId});

  @override
  State<GroupJoinRequestsPage> createState() => _GroupJoinRequestsPageState();
}

class _GroupJoinRequestsPageState extends State<GroupJoinRequestsPage> {
  @override
  void initState() {
    super.initState();
    context.read<GroupBloc>().add(
      GetGroupJoinRequestsEvent(groupId: widget.groupId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(local.groupRequests)),
      body: BlocProvider<NotificationBloc>(
        create: (context) => sl<NotificationBloc>(),
        child: BlocListener<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (state is NotificationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is JoinRequestResponseSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(local.requestHandledSuccessfully),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<GroupBloc>().add(
                GetGroupJoinRequestsEvent(groupId: widget.groupId),
              );
            }
          },
          child: BlocBuilder<GroupBloc, GroupState>(
            builder: (context, state) {
              if (state is GroupJoinRequestsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GroupJoinRequestsLoaded) {
                if (state.requests.isEmpty) {
                  return Center(child: Text(local.noNewRequests));
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<GroupBloc>().add(
                      GetGroupJoinRequestsEvent(groupId: widget.groupId),
                    );
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: state.requests.length,
                    itemBuilder: (context, index) {
                      return JoinRequestListTile(
                        joinRequest: state.requests[index],
                        groupId: widget.groupId,
                      );
                    },
                  ),
                );
              } else if (state is GroupJoinRequestsFailure) {
                return Center(child: Text(state.message));
              }
              return Center(child: Text(local.somethingWentWrong));
            },
          ),
        ),
      ),
    );
  }
}

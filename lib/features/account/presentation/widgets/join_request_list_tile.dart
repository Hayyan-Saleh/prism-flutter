import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/features/account/domain/enitities/notification/join_request_entity.dart';
import 'package:prism/features/account/presentation/bloc/notification/notification_bloc/notification_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class JoinRequestListTile extends StatelessWidget {
  final JoinRequestEntity joinRequest;

  const JoinRequestListTile({super.key, required this.joinRequest});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return ListTile(
      title: Text(joinRequest.name),
      subtitle: Text(joinRequest.username),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              context.read<NotificationBloc>().add(
                    RespondToJoinRequestEvent(
                      groupId: joinRequest.groupId,
                      requestId: joinRequest.id,
                      response: 'approved',
                    ),
                  );
            },
            child: Text(local.approve),
          ),
          TextButton(
            onPressed: () {
              context.read<NotificationBloc>().add(
                    RespondToJoinRequestEvent(
                      groupId: joinRequest.groupId,
                      requestId: joinRequest.id,
                      response: 'rejected',
                    ),
                  );
            },
            child: Text(local.reject),
          ),
        ],
      ),
    );
  }
}

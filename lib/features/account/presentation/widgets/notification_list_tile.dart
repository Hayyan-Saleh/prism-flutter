import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/core/util/widgets/profile_picture.dart';
import 'package:prism/features/account/domain/enitities/account/main/personal_account_entity.dart';
import 'package:prism/features/account/domain/enitities/notification/follow_request_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/features/account/presentation/bloc/notification/notification_bloc/notification_bloc.dart';

class NotificationListTile extends StatelessWidget {
  final FollowRequestEntity followRequest;

  const NotificationListTile({super.key, required this.followRequest});

  Widget _buildTopSection(BuildContext context, int personalAccId) {
    final local = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap:
          () => Navigator.pushNamed(
            context,
            AppRoutes.otherAccPage,
            arguments: {
              'personalAccountId': personalAccId,
              'otherAccountId': followRequest.creator.id,
            },
          ),
      child: Row(
        children: [
          ProfilePicture(link: followRequest.creator.avatar, radius: 30),
          const SizedBox(width: 16),
          Expanded(
            child: RichText(
              overflow: TextOverflow.clip,
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: followRequest.creator.fullName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '   @${followRequest.creator.accountName}    ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withAlpha(150),
                    ),
                  ),
                  TextSpan(
                    text: local.requestedToFollowYou,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppButton(
          onPressed: () {
            context.read<NotificationBloc>().add(
              RespondToFollowRequestEvent(
                requestId: followRequest.id,
                response: 'approved',
              ),
            );
          },
          child: Text(local.accept),
        ),
        const SizedBox(width: 8),
        AppButton(
          bgColor: Colors.red,
          onPressed: () {
            context.read<NotificationBloc>().add(
              RespondToFollowRequestEvent(
                requestId: followRequest.id,
                response: 'rejected',
              ),
            );
          },
          child: Text(local.reject),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary.withAlpha(10),
          borderRadius: BorderRadius.circular(10),
        ),
        child: BlocBuilder<PAccountBloc, PAccountState>(
          builder: (context, state) {
            final PersonalAccountEntity? pAccount =
                state is LoadedPAccountState
                    ? state.personalAccount
                    : context.read<PAccountBloc>().pAccount;

            if (pAccount != null) {
              return Column(
                children: [
                  _buildTopSection(context, pAccount.id),
                  _buildBottomSection(context),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

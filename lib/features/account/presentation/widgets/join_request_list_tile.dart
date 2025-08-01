import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/core/util/widgets/profile_picture.dart';
import 'package:prism/features/account/domain/enitities/notification/join_request_entity.dart';
import 'package:prism/features/account/presentation/bloc/notification/notification_bloc/notification_bloc.dart';

class JoinRequestListTile extends StatelessWidget {
  final int groupId;
  final JoinRequestEntity joinRequest;

  const JoinRequestListTile({
    super.key,
    required this.joinRequest,
    this.groupId = 0,
  });

  Widget _buildTopSection(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Row(
      children: [
        ProfilePicture(link: joinRequest.creator.avatar, radius: 30),
        const SizedBox(width: 16),
        Expanded(
          child: RichText(
            overflow: TextOverflow.clip,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: joinRequest.creator.fullName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' @${joinRequest.creator.accountName} ',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimary.withAlpha(150),
                  ),
                ),
                TextSpan(
                  text: local.requestedToJoinGroup(
                    joinRequest.group?.name ?? '',
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment:
          joinRequest.group != null
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.end,
      children: [
        if (joinRequest.group != null) _buildCachedImage(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                onPressed: () {
                  context.read<NotificationBloc>().add(
                    RespondToJoinRequestEvent(
                      groupId: joinRequest.group?.id ?? groupId,
                      requestId: joinRequest.id,
                      response: 'approved',
                      fromGroup: joinRequest.group == null,
                    ),
                  );
                },
                child: Text(local.approve),
              ),
              const SizedBox(width: 8),
              AppButton(
                bgColor: Colors.red,
                onPressed: () {
                  context.read<NotificationBloc>().add(
                    RespondToJoinRequestEvent(
                      groupId: joinRequest.group?.id ?? groupId,
                      requestId: joinRequest.id,
                      response: 'rejected',
                      fromGroup: joinRequest.group == null,
                    ),
                  );
                },
                child: Text(local.reject),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCachedImage() {
    return SizedBox(
      height: 70,
      width: 70,
      child: CachedNetworkImage(
        imageUrl: joinRequest.group!.avatar ?? '',
        imageBuilder:
            (context, imageProvider) => ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image(image: imageProvider, fit: BoxFit.cover),
            ),
        placeholder:
            (context, url) => const SizedBox(
              height: 100,
              width: 100,
              child: Center(child: CircularProgressIndicator(strokeWidth: 4)),
            ),
        errorWidget:
            (context, url, error) => const SizedBox(
              height: 100,
              width: 100,
              child: Center(child: Icon(Icons.error)),
            ),
      ),
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
        child: Column(
          spacing: 16,
          children: [_buildTopSection(context), _buildBottomSection(context)],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:prism/core/util/widgets/profile_picture.dart';
import 'package:prism/features/live-stream/domain/entities/live_stream_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LiveStreamListItem extends StatelessWidget {
  final LiveStreamEntity stream;

  const LiveStreamListItem({required this.stream, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: ProfilePicture(link: stream.creator.avatar, radius: 30),
        title: Text(stream.creator.fullName),
        subtitle: Text(stream.creator.accountName),
        trailing: Text(AppLocalizations.of(context)!.viewers(stream.views)),
      ),
    );
  }
}

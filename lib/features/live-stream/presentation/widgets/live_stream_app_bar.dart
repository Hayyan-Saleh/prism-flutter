import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/widgets/profile_picture.dart';
import 'package:prism/features/live-stream/domain/entities/live_stream_entity.dart';
import 'package:prism/features/live-stream/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:prism/features/live-stream/presentation/bloc/chat_bloc/chat_event.dart';
import 'package:prism/features/live-stream/presentation/bloc/chat_bloc/chat_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LiveStreamAppBar extends StatelessWidget implements PreferredSizeWidget {
  final LiveStreamEntity stream;
  final bool isCreator;
  final VoidCallback onStop;

  const LiveStreamAppBar({
    super.key,
    required this.stream,
    required this.isCreator,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            ProfilePicture(link: stream.creator.avatar, radius: 32, live: true),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stream.creator.fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    int views = stream.views;
                    if (state is ChatConnected) {
                      views = state.views;
                    }
                    return Text(
                      AppLocalizations.of(context)!.viewers(views),
                      style: const TextStyle(color: Colors.white70),
                    );
                  },
                ),
              ],
            ),
            const Spacer(),
            if (isCreator)
              IconButton(
                icon: const Icon(Icons.stop, color: Colors.white),
                onPressed: onStop,
              )
            else
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  context.read<ChatBloc>().add(
                    DisconnectFromChatEvent(streamKey: stream.streamKey),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'package:fijkplayer_plus/fijkplayer_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/features/account/domain/enitities/account/main/personal_account_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/features/live-stream/domain/entities/chat_message_entity.dart';
import 'package:prism/features/live-stream/domain/entities/live_stream_entity.dart';
import 'package:prism/features/live-stream/presentation/bloc/live_stream_bloc/live_stream_bloc.dart';
import 'package:prism/features/live-stream/presentation/bloc/live_stream_bloc/live_stream_event.dart';

import 'package:prism/features/live-stream/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:prism/features/live-stream/presentation/bloc/chat_bloc/chat_event.dart';
import 'package:prism/features/live-stream/presentation/bloc/chat_bloc/chat_state.dart';
import 'package:prism/features/live-stream/presentation/widgets/chat_message_widget.dart';
import 'package:prism/features/live-stream/presentation/widgets/live_stream_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LiveStreamPage extends StatefulWidget {
  final LiveStreamEntity stream;

  const LiveStreamPage({super.key, required this.stream});

  @override
  LiveStreamPageState createState() => LiveStreamPageState();
}

class LiveStreamPageState extends State<LiveStreamPage> {
  final FijkPlayer _player = FijkPlayer();
  final TextEditingController _chatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(
      ConnectToChatEvent(streamKey: widget.stream.streamKey),
    );
    _player.setDataSource(widget.stream.streamURL, autoPlay: true);
  }

  @override
  void dispose() {
    _player.release();
    _chatController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_chatController.text.isNotEmpty) {
      final pAccount =
          context.read<PAccountBloc>().pAccount as PersonalAccountEntity;
      final message = ChatMessageEntity(
        id: DateTime.now().toIso8601String(),
        name: pAccount.fullName,
        avatar: pAccount.picUrl ?? '',
        text: _chatController.text,
      );
      context.read<ChatBloc>().add(
        SendChatMessageEvent(
          streamKey: widget.stream.streamKey,
          message: message,
        ),
      );
      _chatController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = context.read<PAccountBloc>().pAccount;
    final isCreator = account != null && account.id == widget.stream.creator.id;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          context.read<ChatBloc>().add(
            DisconnectFromChatEvent(streamKey: widget.stream.streamKey),
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: LiveStreamAppBar(
          stream: widget.stream,
          isCreator: isCreator,
          onStop: () {
            context.read<LiveStreamBloc>().add(
              EndStreamEvent(streamKey: widget.stream.streamKey),
            );
          },
        ),
        body: BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatDisconnected) {
              Navigator.of(context).pop();
            }
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: FijkView(player: _player, fit: FijkFit.cover),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withAlpha(180), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.15],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withAlpha(150),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: BlocBuilder<ChatBloc, ChatState>(
                              builder: (context, state) {
                                if (state is ChatConnected) {
                                  return ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black,
                                          Colors.black,
                                          Colors.transparent,
                                        ],
                                        stops: const [0.0, 0.1, 0.9, 1.0],
                                      ).createShader(bounds);
                                    },
                                    blendMode: BlendMode.dstIn,
                                    child: ListView.builder(
                                      reverse: true,
                                      padding: const EdgeInsets.only(bottom: 8),
                                      itemCount: state.messages.length,
                                      itemBuilder:
                                          (ctx, index) => ChatMessageWidget(
                                            message: state.messages[index],
                                          ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _chatController,
                                  decoration: InputDecoration(
                                    hintText:
                                        AppLocalizations.of(
                                          context,
                                        )!.sendMessageHint,
                                    filled: true,
                                    fillColor: Colors.black.withAlpha(125),
                                    hintStyle: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                                onPressed: _sendMessage,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

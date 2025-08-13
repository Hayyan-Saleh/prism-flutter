import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/features/live-stream/domain/entities/live_stream_entity.dart';
import 'package:prism/features/live-stream/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:prism/features/live-stream/presentation/bloc/chat_bloc/chat_event.dart';
import 'package:prism/features/live-stream/presentation/bloc/chat_bloc/chat_state.dart';
import 'package:prism/features/live-stream/presentation/bloc/live_stream_bloc/live_stream_bloc.dart';
import 'package:prism/features/live-stream/presentation/bloc/live_stream_bloc/live_stream_event.dart';
import 'package:prism/features/live-stream/presentation/bloc/rtmp_bloc/rtmp_bloc.dart';
import 'package:prism/features/live-stream/presentation/widgets/chat_message_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyStreamPage extends StatefulWidget {
  final LiveStreamEntity stream;
  final CameraDescription cameraDescription;
  final bool enableAudio;

  const MyStreamPage({
    super.key,
    required this.stream,
    required this.cameraDescription,
    required this.enableAudio,
  });

  @override
  State<MyStreamPage> createState() => _MyStreamPageState();
}

class _MyStreamPageState extends State<MyStreamPage> {
  bool _showMessages = true;

  @override
  void initState() {
    super.initState();
    context.read<RtmpBloc>().add(
      InitializeCameraEvent(
        cameraDescription: widget.cameraDescription,
        enableAudio: widget.enableAudio,
      ),
    );
    context.read<ChatBloc>().add(
      ConnectToChatEvent(streamKey: widget.stream.streamKey),
    );
  }

  void _endStream() {
    context.read<RtmpBloc>().add(StopStreamingEvent());
    context.read<ChatBloc>().add(
      DisconnectFromChatEvent(streamKey: widget.stream.streamKey),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(
                _showMessages ? Icons.chat_bubble : Icons.chat_bubble_outline,
              ),
              title: Text(
                _showMessages
                    ? AppLocalizations.of(context)!.hideChat
                    : AppLocalizations.of(context)!.showChat,
              ),
              onTap: () {
                setState(() {
                  _showMessages = !_showMessages;
                });
                Navigator.of(ctx).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.stop, color: Colors.red),
              title: Text(
                AppLocalizations.of(context)!.stopStreaming,
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.of(ctx).pop();
                _endStream();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _endStream();
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            BlocConsumer<RtmpBloc, RtmpState>(
              listener: (context, state) {
                if (state is RtmpCameraInitialized) {
                  context.read<RtmpBloc>().add(
                    StartStreamingEvent(streamUrl: widget.stream.streamURL),
                  );
                } else if (state is RtmpStopped) {
                  context.read<LiveStreamBloc>().add(
                    EndStreamEvent(streamKey: widget.stream.streamKey),
                  );
                  Navigator.of(context).pop();
                } else if (state is RtmpError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                final rtmpBloc = context.watch<RtmpBloc>();
                final cameraController = rtmpBloc.cameraController;

                if (state is RtmpError) {
                  return Center(child: Text(state.message));
                }

                if (cameraController != null &&
                    cameraController.value.isInitialized) {
                  return SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: CameraPreview(cameraController),
                      ),
                    ),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: getHeight(context),
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 24,
                      bottom: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withAlpha(180),
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withAlpha(180),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.1, 0.8, 1],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.circle, color: Colors.pink),
                                  const SizedBox(width: 4),
                                  Text(
                                    AppLocalizations.of(context)!.myStream,
                                    style:
                                        Theme.of(
                                          context,
                                        ).appBarTheme.titleTextStyle ??
                                        const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  BlocBuilder<ChatBloc, ChatState>(
                                    builder: (context, state) {
                                      if (state is ChatConnected) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0,
                                            vertical: 6.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withAlpha(125),
                                            borderRadius: BorderRadius.circular(
                                              16.0,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.visibility,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                state.views.toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.settings,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _showSettingsBottomSheet(context);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (_showMessages)
                          BlocBuilder<ChatBloc, ChatState>(
                            builder: (context, state) {
                              if (state is ChatConnected) {
                                return SizedBox(
                                  height: 0.3 * getHeight(context),
                                  child: ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors
                                              .transparent, // Fade out at the top
                                          Colors.black, // Solid in the middle
                                          Colors.black, // Solid in the middle
                                          Colors
                                              .transparent, // Fade out at the bottom
                                        ],
                                        stops: const [
                                          0.0,
                                          0.1,
                                          0.9,
                                          1.0,
                                        ], // Adjust stops for gradient range
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
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          )
                        else
                          const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

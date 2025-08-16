import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';

class CachedNetworkVideo extends StatefulWidget {
  final String videoUrl;
  final bool showControls;
  final VoidCallback? onEnd;
  final ValueChanged<double>? onDurationLoaded;

  const CachedNetworkVideo({
    required this.videoUrl,
    this.showControls = false,
    this.onEnd,
    this.onDurationLoaded,
    super.key,
  });

  @override
  CachedNetworkVideoState createState() => CachedNetworkVideoState();
}

class CachedNetworkVideoState extends State<CachedNetworkVideo> {
  late BetterPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    _controller = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        aspectRatio: 16 / 9,
        errorBuilder:
            (context, errorMessage) => Center(
              child: Text(
                'Error loading video',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
        handleLifecycle: true,
        autoDetectFullscreenDeviceOrientation: true,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControls: widget.showControls,
        ),
        eventListener: (event) {
          if (event.betterPlayerEventType ==
              BetterPlayerEventType.initialized) {
            final duration =
                _controller.videoPlayerController?.value.duration?.inSeconds
                    .toDouble();
            if (duration != null && widget.onDurationLoaded != null) {
              widget.onDurationLoaded!(duration);
            }
          }
          if (event.betterPlayerEventType == BetterPlayerEventType.finished &&
              widget.onEnd != null) {
            widget.onEnd!();
          }
        },
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.videoUrl,
        cacheConfiguration: const BetterPlayerCacheConfiguration(
          useCache: true,
          maxCacheSize: 10 * 1024 * 1024,
          maxCacheFileSize: 10 * 1024 * 1024,
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(CachedNetworkVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl ||
        oldWidget.showControls != widget.showControls) {
      _controller.pause();
      _controller.dispose();
      _initializePlayer();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayer(controller: _controller),
    );
  }
}

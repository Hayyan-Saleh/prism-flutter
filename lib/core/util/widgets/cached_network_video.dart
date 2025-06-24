import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class CachedNetworkVideo extends StatefulWidget {
  final String videoUrl;

  const CachedNetworkVideo({required this.videoUrl, super.key});

  @override
  _CachedNetworkVideoState createState() => _CachedNetworkVideoState();
}

class _CachedNetworkVideoState extends State<CachedNetworkVideo> {
  late BetterPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BetterPlayerController(
      const BetterPlayerConfiguration(autoPlay: true, aspectRatio: 16 / 9),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.videoUrl,
        cacheConfiguration: const BetterPlayerCacheConfiguration(
          useCache: true,
          maxCacheSize: 10 * 1024 * 1024, // 10 MB
          maxCacheFileSize: 10 * 1024 * 1024,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BetterPlayer(controller: _controller);
  }
}

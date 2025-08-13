import 'package:camera/camera.dart';
import 'package:prism/features/live-stream/data/services/ffmpeg_service.dart';

abstract class LiveStreamLocalDataSource {
  Future<void> startStreaming(
    String streamUrl,
    CameraController cameraController,
  );
  Future<void> stopStreaming(CameraController? cameraController);
}

class LiveStreamLocalDataSourceImpl implements LiveStreamLocalDataSource {
  final FfmpegService ffmpegService;

  LiveStreamLocalDataSourceImpl({required this.ffmpegService});

  @override
  Future<void> startStreaming(
    String streamUrl,
    CameraController cameraController,
  ) {
    return ffmpegService.startStreaming(streamUrl, cameraController);
  }

  @override
  Future<void> stopStreaming(CameraController? cameraController) {
    return ffmpegService.stopStreaming(cameraController);
  }
}

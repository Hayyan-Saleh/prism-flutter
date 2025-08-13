import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/live-stream/domain/repository/live_stream_repository.dart';

class StartStreamingUseCase {
  final LiveStreamRepository repository;

  StartStreamingUseCase(this.repository);

  Future<Either<AppFailure, void>> call(
    String streamUrl,
    CameraController cameraController,
  ) {
    return repository.startStreaming(streamUrl, cameraController);
  }
}

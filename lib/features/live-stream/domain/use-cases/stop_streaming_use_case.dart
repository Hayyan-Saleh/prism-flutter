import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/live-stream/domain/repository/live_stream_repository.dart';

class StopStreamingUseCase {
  final LiveStreamRepository repository;

  StopStreamingUseCase(this.repository);

  Future<Either<AppFailure, void>> call(CameraController? cameraController) {
    return repository.stopStreaming(cameraController);
  }
}
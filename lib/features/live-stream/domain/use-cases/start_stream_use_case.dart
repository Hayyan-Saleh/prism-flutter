import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/live-stream/domain/entities/live_stream_entity.dart';
import 'package:prism/features/live-stream/domain/repository/live_stream_repository.dart';

class StartStreamUseCase {
  final LiveStreamRepository repository;

  StartStreamUseCase(this.repository);

  Future<Either<AppFailure, LiveStreamEntity>> call() {
    return repository.startStream();
  }
}

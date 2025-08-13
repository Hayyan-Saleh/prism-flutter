import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/live-stream/domain/repository/live_stream_repository.dart';

class EndStreamUseCase {
  final LiveStreamRepository repository;

  EndStreamUseCase(this.repository);

  Future<Either<AppFailure, void>> call(String streamKey) {
    return repository.endStream(streamKey);
  }
}

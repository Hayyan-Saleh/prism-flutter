import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/live-stream/domain/repository/chat_repository.dart';

class GetStreamEndedUseCase {
  final ChatRepository repository;

  GetStreamEndedUseCase(this.repository);

  Either<AppFailure, Stream<void>> call() {
    return repository.getStreamEnded();
  }
}

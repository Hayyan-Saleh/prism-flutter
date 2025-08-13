import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/live-stream/domain/repository/chat_repository.dart';

class DisconnectFromChatUseCase {
  final ChatRepository repository;

  DisconnectFromChatUseCase(this.repository);

  Future<Either<AppFailure, void>> call(String streamKey) {
    return repository.disconnect(streamKey);
  }
}

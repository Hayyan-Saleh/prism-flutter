import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/live-stream/domain/repository/chat_repository.dart';

class ConnectToChatUseCase {
  final ChatRepository repository;

  ConnectToChatUseCase(this.repository);

  Future<Either<AppFailure, void>> call(String streamKey) {
    return repository.connect(streamKey);
  }
}

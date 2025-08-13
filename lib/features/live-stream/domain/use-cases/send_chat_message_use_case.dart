import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/live-stream/domain/entities/chat_message_entity.dart';
import 'package:prism/features/live-stream/domain/repository/chat_repository.dart';

class SendChatMessageUseCase {
  final ChatRepository repository;

  SendChatMessageUseCase(this.repository);

  Future<Either<AppFailure, ChatMessageEntity>> call(
      String streamKey, ChatMessageEntity message) {
    return repository.sendMessage(streamKey, message);
  }
}

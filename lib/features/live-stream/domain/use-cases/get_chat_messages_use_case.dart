import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/live-stream/domain/entities/chat_message_entity.dart';
import 'package:prism/features/live-stream/domain/repository/chat_repository.dart';

class GetChatMessagesUseCase {
  final ChatRepository repository;

  GetChatMessagesUseCase(this.repository);

  Either<AppFailure, Stream<ChatMessageEntity>> call() {
    return repository.getMessages();
  }
}

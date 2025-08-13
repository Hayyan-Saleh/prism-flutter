import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/live-stream/domain/entities/chat_message_entity.dart';

abstract class ChatRepository {
  Future<Either<AppFailure, void>> connect(String streamKey);
  Future<Either<AppFailure, void>> disconnect(String streamKey);
  Future<Either<AppFailure, ChatMessageEntity>> sendMessage(
      String streamKey, ChatMessageEntity message);
  Either<AppFailure, Stream<ChatMessageEntity>> getMessages();
  Either<AppFailure, Stream<int>> getViews();
  Either<AppFailure, Stream<void>> getStreamEnded();
}

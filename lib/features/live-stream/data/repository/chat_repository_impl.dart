import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/core/errors/failures/server_failure.dart';
import 'package:prism/features/live-stream/data/data-sources/chat_remote_data_source.dart';
import 'package:prism/features/live-stream/domain/entities/chat_message_entity.dart';
import 'package:prism/features/live-stream/domain/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<AppFailure, void>> connect(String streamKey) async {
    try {
      remoteDataSource.connect(streamKey);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> disconnect(String streamKey) async {
    try {
      remoteDataSource.disconnect(streamKey);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, ChatMessageEntity>> sendMessage(
    String streamKey,
    ChatMessageEntity message,
  ) async {
    try {
      final sentMessage = remoteDataSource.sendMessage(streamKey, message);
      return Right(sentMessage);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Either<AppFailure, Stream<ChatMessageEntity>> getMessages() {
    try {
      return Right(remoteDataSource.messages);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Either<AppFailure, Stream<int>> getViews() {
    try {
      return Right(remoteDataSource.views);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Either<AppFailure, Stream<void>> getStreamEnded() {
    try {
      return Right(remoteDataSource.streamEnded);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:your_app/core/errors/exceptions.dart';
import 'package:your_app/core/errors/failures.dart';
import 'package:your_app/core/network/network_info.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/repositories/comment_repository.dart';
import '../datasources/comment_remote_data_source.dart';
import '../models/comment_model.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const CommentRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CommentEntity>>> getComments(
    String postId, {
    int page = 1,
    int limit = 10,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final comments = await remoteDataSource.getComments(
          postId,
          page: page,
          limit: limit,
        );
        return Right(comments.map((model) => model.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, CommentEntity>> addComment(
    CommentEntity comment,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final model = CommentModel.fromEntity(comment);
        final addedComment = await remoteDataSource.addComment(model);
        return Right(addedComment.toEntity());
      } on ServerException {
        return Left(ServerFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateComment(CommentEntity comment) async {
    if (await networkInfo.isConnected) {
      try {
        final model = CommentModel.fromEntity(comment);
        await remoteDataSource.updateComment(model);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(String commentId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteComment(commentId);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> likeComment(
    String commentId,
    String userId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.likeComment(commentId, userId);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> unlikeComment(
    String commentId,
    String userId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.unlikeComment(commentId, userId);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }
}

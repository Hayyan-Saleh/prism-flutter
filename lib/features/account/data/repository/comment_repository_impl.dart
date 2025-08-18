// lib/features/comments/data/repositories/comment_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/exceptions/network_exception.dart';
import 'package:prism/core/errors/exceptions/server_exception.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/core/util/sevices/token_service.dart';
import 'package:prism/features/account/data/data-sources/comment/comment_remote_data_source.dart';
import 'package:prism/features/account/domain/enitities/comment/paginated_comment_entity.dart';
import 'package:prism/features/account/domain/enitities/comment/comment_entity.dart';
import 'package:prism/features/account/domain/repository/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;
  final TokenService tokenService;

  const CommentRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenService,
  });

  Future<Either<AccountFailure, T>> _withToken<T>(
    Future<T> Function(String token) operation,
  ) async {
    try {
      final tokenResult = await tokenService.getToken();
      return await tokenResult.fold(
        (coreFailure) => Left(AccountFailure(coreFailure.message)),
        (token) async {
          try {
            final result = await operation(token);
            return Right(result);
          } on ServerException catch (e) {
            return Left(AccountFailure(e.message));
          } on NetworkException catch (e) {
            return Left(AccountFailure(e.message));
          } catch (e) {
            return Left(AccountFailure('Unexpected error: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      return Left(AccountFailure('Token retrieval failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<AccountFailure, PaginatedCommentsEntity>> getComments({
    required int pageNum,
    int? postId,
    int? adId,
    int? commentId,
  }) async {
    return _withToken((token) async {
      final paginated = await remoteDataSource.getComments(
        token: token,
        page: pageNum,
        postId: postId,
        adId: adId,
        commentId: commentId,
      );
      return paginated;
    });
  }

  @override
  Future<Either<AccountFailure, CommentEntity>> addComment({
    required String text,
    required String commentableType,
    required int commentableId,
  }) async {
    return _withToken((token) async {
      final c = await remoteDataSource.addComment(
        token: token,
        text: text,
        commentableType: commentableType,
        commentableId: commentableId,
      );
      return c;
    });
  }

  @override
  Future<Either<AccountFailure, CommentEntity>> updateComment({
    required int id,
    required String text,
  }) async {
    return _withToken((token) async {
      final c = await remoteDataSource.updateComment(
        token: token,
        id: id,
        text: text,
      );
      return c;
    });
  }

  @override
  Future<Either<AccountFailure, void>> deleteComment({required int id}) async {
    return _withToken((token) async {
      await remoteDataSource.deleteComment(token: token, id: id);
    });
  }

  @override
  Future<Either<AccountFailure, void>> toggleLikeComment({
    required int commentId,
  }) async {
    return _withToken((token) async {
      await remoteDataSource.toggleLikeComment(
        token: token,
        commentId: commentId,
      );
    });
  }
}

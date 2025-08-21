// lib/features/account/domain/repository/comment_repository.dart
import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/enitities/comment/paginated_comment_entity.dart';
import 'package:prism/features/account/domain/enitities/comment/comment_entity.dart';

abstract class CommentRepository {
  Future<Either<AccountFailure, PaginatedCommentsEntity>> getComments({
    required int pageNum,
    int? postId,
    int? adId,
    int? commentId,
  });

  Future<Either<AccountFailure, CommentEntity>> addComment({
    required String text,
    required String commentableType, // Post | Ad | Comment
    required int commentableId,
  });

  Future<Either<AccountFailure, CommentEntity>> updateComment({
    required int id,
    required String text,
  });

  Future<Either<AccountFailure, void>> deleteComment({required int id});

  Future<Either<AccountFailure, void>> toggleLikeComment({
    required int commentId,
  });
}

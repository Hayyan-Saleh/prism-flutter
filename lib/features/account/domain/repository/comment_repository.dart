import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/enitities/comment/comment_entity.dart';
import 'package:prism/features/account/domain/enitities/comment/paginated_comment_entity.dart';

abstract class CommentRepository {
  Future<Either<AccountFailure, PaginatedCommentsEntity>> getComments({
    required String postId,
    required int pageNum,
  });

  Future<Either<AccountFailure, Unit>> addComment({
    required CommentEntity comment,
    required String postId,
  });
  Future<Either<AccountFailure, Unit>> editComment({
    required CommentEntity comment,
    required String postId,
  });
  Future<Either<AccountFailure, Unit>> addReply({
    required CommentEntity comment,
    required String commentId,
  });

  Future<Either<AccountFailure, Unit>> deleteComment({
    required String commentId,
  });
}

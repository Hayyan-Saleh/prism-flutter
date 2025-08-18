// lib/features/comments/domain/use-cases/get_comments_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/enitities/comment/paginated_comment_entity.dart';
import 'package:prism/features/account/domain/repository/comment_repository.dart';

class GetCommentsUseCase {
  final CommentRepository repository;

  GetCommentsUseCase({required this.repository});

  Future<Either<AccountFailure, PaginatedCommentsEntity>> call({
    required int pageNum,
    int? postId,
    int? adId,
    int? commentId,
  }) async {
    return await repository.getComments(
      pageNum: pageNum,
      postId: postId,
      adId: adId,
      commentId: commentId,
    );
  }
}

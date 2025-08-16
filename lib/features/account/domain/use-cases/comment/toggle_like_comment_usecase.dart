// lib/features/comments/domain/use-cases/toggle_like_comment_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/repository/comment_repository.dart';

class ToggleLikeCommentUseCase {
  final CommentRepository repository;
  ToggleLikeCommentUseCase({required this.repository});

  Future<Either<AccountFailure, void>> call({required int commentId}) {
    return repository.toggleLikeComment(commentId: commentId);
  }
}

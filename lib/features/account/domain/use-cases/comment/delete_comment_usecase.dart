// lib/features/comments/domain/use-cases/delete_comment_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/repository/comment_repository.dart';

class DeleteCommentUseCase {
  final CommentRepository repository;
  DeleteCommentUseCase({required this.repository});

  Future<Either<AccountFailure, void>> call({required int id}) {
    return repository.deleteComment(id: id);
  }
}

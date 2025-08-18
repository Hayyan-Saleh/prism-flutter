// lib/features/comments/domain/use-cases/update_comment_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/enitities/comment/comment_entity.dart';
import 'package:prism/features/account/domain/repository/comment_repository.dart';

class UpdateCommentUseCase {
  final CommentRepository repository;
  UpdateCommentUseCase({required this.repository});

  Future<Either<AccountFailure, CommentEntity>> call({
    required int id,
    required String text,
  }) {
    return repository.updateComment(id: id, text: text);
  }
}

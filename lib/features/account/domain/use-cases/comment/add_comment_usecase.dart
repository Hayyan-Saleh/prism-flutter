// lib/features/comments/domain/use-cases/add_comment_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/enitities/comment/comment_entity.dart';
import 'package:prism/features/account/domain/repository/comment_repository.dart';

class AddCommentUseCase {
  final CommentRepository repository;
  AddCommentUseCase({required this.repository});

  Future<Either<AccountFailure, CommentEntity>> call({
    required String text,
    required String commentableType, // Post | Ad | Comment
    required int commentableId,
  }) {
    return repository.addComment(
      text: text,
      commentableType: commentableType,
      commentableId: commentableId,
    );
  }
}

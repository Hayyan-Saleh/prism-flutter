import 'package:dartz/dartz.dart';
import 'package:your_app/core/errors/failures.dart';
import 'package:your_app/core/usecases/usecase.dart';
import '../repositories/comment_repository.dart';

class UnlikeComment implements UseCase<void, UnlikeCommentParams> {
  final CommentRepository repository;

  const UnlikeComment(this.repository);

  @override
  Future<Either<Failure, void>> call(UnlikeCommentParams params) {
    return repository.unlikeComment(params.commentId, params.userId);
  }
}

class UnlikeCommentParams {
  final String commentId;
  final String userId;

  const UnlikeCommentParams({required this.commentId, required this.userId});
}

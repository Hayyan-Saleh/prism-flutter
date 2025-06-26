import 'package:dartz/dartz.dart';
import 'package:your_app/core/errors/failures.dart';
import 'package:your_app/core/usecases/usecase.dart';
import '../repositories/comment_repository.dart';

class LikeComment implements UseCase<void, LikeCommentParams> {
  final CommentRepository repository;

  const LikeComment(this.repository);

  @override
  Future<Either<Failure, void>> call(LikeCommentParams params) {
    return repository.likeComment(params.commentId, params.userId);
  }
}

class LikeCommentParams {
  final String commentId;
  final String userId;

  const LikeCommentParams({required this.commentId, required this.userId});
}

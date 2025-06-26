import 'package:dartz/dartz.dart';
import 'package:your_app/core/errors/failures.dart';
import 'package:your_app/core/usecases/usecase.dart';
import '../repositories/comment_repository.dart';

class DeleteComment implements UseCase<void, String> {
  final CommentRepository repository;

  const DeleteComment(this.repository);

  @override
  Future<Either<Failure, void>> call(String commentId) {
    return repository.deleteComment(commentId);
  }
}

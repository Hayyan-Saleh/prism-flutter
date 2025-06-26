import 'package:dartz/dartz.dart';
import 'package:your_app/core/errors/failures.dart';
import 'package:your_app/core/usecases/usecase.dart';
import '../entities/comment_entity.dart';
import '../repositories/comment_repository.dart';

class UpdateComment implements UseCase<void, CommentEntity> {
  final CommentRepository repository;

  const UpdateComment(this.repository);

  @override
  Future<Either<Failure, void>> call(CommentEntity comment) {
    return repository.updateComment(comment);
  }
}

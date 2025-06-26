import 'package:dartz/dartz.dart';
import 'package:your_app/core/errors/failures.dart';
import 'package:your_app/core/usecases/usecase.dart';
import '../entities/comment_entity.dart';
import '../repositories/comment_repository.dart';

class AddComment implements UseCase<CommentEntity, CommentEntity> {
  final CommentRepository repository;
  
  const AddComment(this.repository);
  
  @override
  Future<Either<Failure, CommentEntity>> call(CommentEntity comment) {
    return repository.addComment(comment);
  }
}
import 'package:dartz/dartz.dart';
import 'package:your_app/core/errors/failures.dart';
import 'package:your_app/core/usecases/usecase.dart';
import '../entities/comment_entity.dart';
import '../repositories/comment_repository.dart';

class GetComments implements UseCase<List<CommentEntity>, GetCommentsParams> {
  final CommentRepository repository;
  
  const GetComments(this.repository);
  
  @override
  Future<Either<Failure, List<CommentEntity>>> call(GetCommentsParams params) {
    return repository.getComments(
      params.postId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetCommentsParams {
  final String postId;
  final int page;
  final int limit;
  
  const GetCommentsParams({
    required this.postId,
    this.page = 1,
    this.limit = 10,
  });
}
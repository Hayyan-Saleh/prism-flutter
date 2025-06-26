import 'package:dartz/dartz.dart';
import 'package:your_app/core/errors/failures.dart';
import '../entities/comment_entity.dart';

abstract class CommentRepository {
  Future<Either<Failure, List<CommentEntity>>> getComments(
    String postId, {
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, CommentEntity>> addComment(CommentEntity comment);
  
  Future<Either<Failure, void>> updateComment(CommentEntity comment);
  
  Future<Either<Failure, void>> deleteComment(String commentId);
  
  Future<Either<Failure, void>> likeComment(String commentId, String userId);
  
  Future<Either<Failure, void>> unlikeComment(String commentId, String userId);
}
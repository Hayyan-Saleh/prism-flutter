import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/enitities/post/post_entity.dart';
import 'package:prism/features/account/domain/enitities/post/post_pagination_entity.dart';

abstract class PostRepository {
  Future<Either<AccountFailure, PaginatedPostsEntity>> getPosts({
    String? accountId,
    required int pageNum,
  });

  Future<Either<AccountFailure, Unit>> addPost({
    required String accountId,
    required PostEntity post,
  });
  Future<Either<AccountFailure, Unit>> editPost({
    required String accountId,
    required PostEntity post,
  });

  Future<Either<AccountFailure, Unit>> savePost({
    required String personalAccountId,
    required PostEntity post,
  });

  Future<Either<AccountFailure, Unit>> deletePost({required String postId});
}

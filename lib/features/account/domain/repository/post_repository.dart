import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/enitities/post/post_pagination_entity.dart';

abstract class PostRepository {
  Future<Either<AccountFailure, PaginatedPostsEntity>> getFeedPosts({
    required int pageNum,
  });

  Future<Either<AccountFailure, PaginatedPostsEntity>> getPersonalPosts({
    required int? accountId,
    required int pageNum,
  });

  Future<Either<AccountFailure, PaginatedPostsEntity>> getSavedPosts({
    int pageNum = 1,
  });
  Future<Either<AccountFailure, Unit>> addPost({
    required String? text,
    required String privacy,
    int? groupId,
    List<String>? mediaPaths,
  });

  Future<Either<AccountFailure, Unit>> updatePost({
    required int postId,
    String? text,
    String? privacy,
    List<File>? mediaFiles,
    List<int>? removedMediaIds,
  });

  Future<Either<AccountFailure, Unit>> savePost({required int postId});

  Future<Either<AccountFailure, Unit>> unsavePost({required int postId});

  Future<Either<AccountFailure, Unit>> deletePost({required int postId});

  Future<Either<AccountFailure, Unit>> toggleLikePost({required int postId});
}

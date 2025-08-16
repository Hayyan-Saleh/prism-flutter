// lib/features/account/data/repositories/post_repository_impl.dart

import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/exceptions/network_exception.dart';
import 'package:prism/core/errors/exceptions/server_exception.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/core/util/sevices/token_service.dart';
import 'package:prism/features/account/data/data-sources/post/post_remote_data_source.dart';
import 'package:prism/features/account/domain/enitities/post/post_pagination_entity.dart';
import 'package:prism/features/account/domain/repository/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final TokenService tokenService;

  const PostRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenService,
  });

  Future<Either<AccountFailure, T>> _withToken<T>(
    Future<T> Function(String token) operation,
  ) async {
    try {
      final tokenResult = await tokenService.getToken();
      return await tokenResult.fold(
        (coreFailure) => Left(AccountFailure(coreFailure.message)),
        (token) async {
          try {
            final result = await operation(token);
            return Right(result);
          } on ServerException catch (e) {
            return Left(AccountFailure(e.message));
          } on NetworkException catch (e) {
            return Left(AccountFailure(e.message));
          } catch (e) {
            return Left(
              AccountFailure('An unexpected error occurred: ${e.toString()}'),
            );
          }
        },
      );
    } catch (e) {
      return Left(
        AccountFailure(
          'An unexpected error occurred during token retrieval: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<AccountFailure, PaginatedPostsEntity>> getFeedPosts({
    required int pageNum,
  }) async {
    return _withToken((token) async {
      final paginatedPostsModel = await remoteDataSource.getFeedPosts(
        token: token,
        page: pageNum,
      );
      return paginatedPostsModel;
    });
  }

  @override
  Future<Either<AccountFailure, PaginatedPostsEntity>> getPersonalPosts({
    required int? accountId,
    required int pageNum,
  }) async {
    return _withToken((token) async {
      final paginatedPostsModel = await remoteDataSource.getPersonalPosts(
        token: token,
        userId: accountId,
        page: pageNum,
      );
      return paginatedPostsModel;
    });
  }

@override
Future<Either<AccountFailure, PaginatedPostsEntity>> getSavedPosts({int pageNum = 1}) async {
  return _withToken((token) async {
    final savedPostsModel = await remoteDataSource.getSavedPosts(
      token: token,
      page: pageNum, // انتبه هنا للمعامل اسم 'page' وليس 'pageNum' لكي يتسق مع التوابع الباقية
    );

    // إذا كان savedPostsModel بالفعل من نوع PaginatedPostsEntity (كما يفعل باقي التوابع)، فقط ارجعه:
    return savedPostsModel;

    // إذا كنت تحتاج تحويل Model إلى Entity:
    // final paginatedPostsEntity = PaginatedPostsEntity(
    //   posts: savedPostsModel.posts.map((e) => e.toEntity()).toList(),
    //   pagination: savedPostsModel.pagination.toEntity(),
    // );
    // return paginatedPostsEntity;
  });
}


  @override
  Future<Either<AccountFailure, Unit>> addPost({
    required String? text,
    required String privacy,
    int? groupId,
    List<String>? mediaPaths,
  }) async {
    return _withToken((token) async {
      List<File>? mediaFiles;
      if (mediaPaths != null && mediaPaths.isNotEmpty) {
        mediaFiles = mediaPaths.map((path) => File(path)).toList();
      }

      await remoteDataSource.createPost(
        token: token,
        text: text,
        privacy: privacy,
        groupId: groupId,
        mediaFiles: mediaFiles,
      );
      return unit;
    });
  }

  @override
  Future<Either<AccountFailure, Unit>> updatePost({
    required int postId,
    String? text,
    String? privacy,
    List<File>? mediaFiles,
    List<int>? removedMediaIds,
  }) async {
    return _withToken((token) async {
      await remoteDataSource.updatePost(
        token: token,
        postId: postId,
        text: text,
        privacy: privacy,
        mediaFiles: mediaFiles,
        removedMediaIds: removedMediaIds,
      );
      return unit;
    });
  }

  @override
  Future<Either<AccountFailure, Unit>> savePost({required int postId}) async {
    return _withToken((token) async {
      await remoteDataSource.savePost(token: token, postId: postId);
      return unit;
    });
  }

  @override
  Future<Either<AccountFailure, Unit>> unsavePost({required int postId}) async {
    return _withToken((token) async {
      await remoteDataSource.unsavePost(token: token, postId: postId);
      return unit;
    });
  }

  @override
  Future<Either<AccountFailure, Unit>> deletePost({required int postId}) async {
    return _withToken((token) async {
      await remoteDataSource.deletePost(token: token, postId: postId);
      return unit;
    });
  }

  @override
  Future<Either<AccountFailure, Unit>> toggleLikePost({
    required int postId,
  }) async {
    return _withToken((token) async {
      await remoteDataSource.toggleLikePost(token: token, postId: postId);
      return unit;
    });
  }
}

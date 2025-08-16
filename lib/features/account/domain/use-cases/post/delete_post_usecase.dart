// lib/features/account/domain/use-cases/post/delete_post_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/repository/post_repository.dart';

class DeletePostUseCase {
  final PostRepository repository;

  DeletePostUseCase({required this.repository});

  Future<Either<AccountFailure, Unit>> call({required int postId}) async {
    return await repository.deletePost(postId: postId);
  }
}
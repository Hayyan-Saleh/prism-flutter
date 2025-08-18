
import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/repository/post_repository.dart';

class UnsavePostUseCase {
  final PostRepository repository;

  UnsavePostUseCase({required this.repository});

  Future<Either<AccountFailure, Unit>> call({required int postId}) async {
    return await repository.unsavePost(postId: postId);
  }
}
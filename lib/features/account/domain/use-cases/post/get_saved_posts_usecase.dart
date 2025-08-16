import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/enitities/post/post_pagination_entity.dart';
import 'package:prism/features/account/domain/repository/post_repository.dart';

class GetSavedPostsUseCase {
  final PostRepository repository;

  GetSavedPostsUseCase({required this.repository});

  Future<Either<AccountFailure, PaginatedPostsEntity>> call({required int pageNum }) async {
    return await repository.getSavedPosts(pageNum: pageNum);
  }
}

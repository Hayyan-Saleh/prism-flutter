// lib/features/account/domain/use-cases/post/get_all_posts_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart'; // لاحظ استخدام AccountFailure
import 'package:prism/features/account/domain/enitities/post/post_pagination_entity.dart';
import 'package:prism/features/account/domain/repository/post_repository.dart';

class GetPersonalPostsUseCase {
  final PostRepository repository;

  GetPersonalPostsUseCase({required this.repository});

  Future<Either<AccountFailure, PaginatedPostsEntity>> call({
    required int? accountId,
    required int pageNum,
  }) async {
    return await repository.getPersonalPosts(accountId: accountId, pageNum: pageNum);
  }
}
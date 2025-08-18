import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/enitities/post/post_pagination_entity.dart';
import 'package:prism/features/account/domain/repository/post_repository.dart';

class GetFeedPostsUseCase {
  final PostRepository repository;

  GetFeedPostsUseCase({required this.repository});

  Future<Either<AccountFailure, PaginatedPostsEntity>> call({required int pageNum}) {
    // لا تحتاج userId لأن هذا للfeed العام
    return repository.getFeedPosts(pageNum: pageNum);
  }
}

import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/paginated_groups_entity.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class ExploreGroupsUseCase {
  final AccountRepository repository;

  ExploreGroupsUseCase({required this.repository});

  Future<Either<AccountFailure, PaginatedGroupsEntity>> call({
    required int page,
  }) async {
    return await repository.exploreGroups(page: page);
  }
}

import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class GetFollowingUsecase {
  final AccountRepository repository;

  GetFollowingUsecase({required this.repository});

  Future<Either<AccountFailure, List<SimplifiedAccountEntity>>> call({
    required int accountId,
  }) async {
    return await repository.getFollowing(accountId: accountId);
  }
}

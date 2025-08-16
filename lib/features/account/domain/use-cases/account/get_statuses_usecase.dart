import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/enitities/account/status/status_entity.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class GetStatusesUsecase {
  final AccountRepository repository;

  GetStatusesUsecase({required this.repository});

  Future<Either<AccountFailure, List<StatusEntity>>> call({
    required int accountId,
  }) async {
    return await repository.getStatuses(accountId: accountId);
  }
}

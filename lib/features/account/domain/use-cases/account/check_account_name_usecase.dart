import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class CheckAccountNameUsecase {
  final AccountRepository repository;

  CheckAccountNameUsecase({required this.repository});

  Future<Either<AccountFailure, bool>> call({
    required String accountName,
  }) async {
    return await repository.checkAccountName(accountName: accountName);
  }
}

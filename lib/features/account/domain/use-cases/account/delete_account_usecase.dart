import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class DeleteAccountUsecase {
  final AccountRepository repository;

  DeleteAccountUsecase({required this.repository});

  Future<Either<AccountFailure, Unit>> call() async {
    return await repository.deleteAccount();
  }
}

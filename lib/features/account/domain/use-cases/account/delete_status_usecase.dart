import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class DeleteStatusUsecase {
  final AccountRepository repository;

  DeleteStatusUsecase({required this.repository});

  Future<Either<AccountFailure, Unit>> call({required int statusId}) async {
    return await repository.deleteStatus(statusId: statusId);
  }
}

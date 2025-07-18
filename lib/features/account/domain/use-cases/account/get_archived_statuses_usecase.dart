import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/enitities/account/status/status_entity.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class GetArchivedStatusesUsecase {
  final AccountRepository repository;

  GetArchivedStatusesUsecase({required this.repository});

  Future<Either<AccountFailure, List<StatusEntity>>> call() async {
    return await repository.getArchivedStatuses();
  }
}

import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class DeleteGroupUseCase {
  final AccountRepository repository;

  DeleteGroupUseCase({required this.repository});

  Future<Either<AccountFailure, Unit>> call({
    required int groupId,
  }) async {
    return await repository.deleteGroup(groupId: groupId);
  }
}

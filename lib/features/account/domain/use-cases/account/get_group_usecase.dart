import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/enitities/account/main/group_entity.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class GetGroupUseCase {
  final AccountRepository repository;

  GetGroupUseCase({required this.repository});

  Future<Either<AccountFailure, GroupEntity>> call({
    required int groupId,
  }) async {
    return await repository.getGroup(groupId: groupId);
  }
}

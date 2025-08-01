import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/enitities/account/main/account_role.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class UpdateGroupMemberRoleUseCase {
  final AccountRepository repository;

  UpdateGroupMemberRoleUseCase({required this.repository});

  Future<Either<AccountFailure, void>> call(
    UpdateGroupMemberRoleParams params,
  ) async {
    return await repository.updateGroupMemberRole(
      groupId: params.groupId,
      userId: params.userId,
      role: params.role,
    );
  }
}

class UpdateGroupMemberRoleParams {
  final int groupId;
  final int userId;
  final AccountRole role;

  UpdateGroupMemberRoleParams({
    required this.groupId,
    required this.userId,
    required this.role,
  });
}

import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/account/domain/enitities/account/main/join_status_enum.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class ToggleGroupMembershipUseCase {
  final AccountRepository repository;

  ToggleGroupMembershipUseCase({required this.repository});

  Future<Either<AppFailure, JoinStatus>> call({
    required int groupId,
    required bool join,
  }) async {
    return await repository.updateGroupMembershipStatus(
      groupId: groupId,
      join: join,
    );
  }
}
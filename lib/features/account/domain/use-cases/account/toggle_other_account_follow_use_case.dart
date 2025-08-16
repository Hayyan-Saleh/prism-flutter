import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/account/domain/enitities/account/main/follow_status_enum.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class ToggleOAccountFollowUseCase {
  final AccountRepository repository;

  ToggleOAccountFollowUseCase({required this.repository});

  Future<Either<AppFailure, FollowStatus>> call({
    required int targetId,
    required bool newStatus,
  }) async {
    return await repository.updateFollowingStatus(
      targetId: targetId,
      newStatus: newStatus,
    );
  }
}

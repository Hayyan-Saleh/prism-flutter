import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class ToggleLikeStatusUseCase {
  final AccountRepository repository;

  ToggleLikeStatusUseCase({required this.repository});

  Future<Either<AppFailure, Unit>> call(int statusId) async {
    return await repository.toggleLikeStatus(statusId: statusId);
  }
}

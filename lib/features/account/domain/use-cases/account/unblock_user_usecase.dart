import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class UnblockUserUseCase {
  final AccountRepository repository;

  UnblockUserUseCase({required this.repository});

  Future<Either<AppFailure, Unit>> call({required int targetId}) async {
    return await repository.unblockUser(targetId: targetId);
  }
}

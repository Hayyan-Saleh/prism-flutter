import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class BlockUserUsecase {
  final AccountRepository repository;

  BlockUserUsecase({required this.repository});

  Future<Either<AccountFailure, Unit>> call(int params) async {
    return await repository.blockUser(targetId: params);
  }
}

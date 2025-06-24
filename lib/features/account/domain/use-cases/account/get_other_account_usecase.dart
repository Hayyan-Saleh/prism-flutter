import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/account/domain/enitities/account/main/other_account_entity.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class GetOtherAccountUsecase {
  final AccountRepository repository;

  GetOtherAccountUsecase({required this.repository});

  Future<Either<AppFailure, OtherAccountEntity>> call({
    required String id,
  }) async {
    return await repository.getOtherAccount(id: id);
  }
}

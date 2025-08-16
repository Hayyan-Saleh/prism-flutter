import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/account/domain/enitities/account/main/personal_account_entity.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class GetLocalPersonalAccountUsecase {
  final AccountRepository repository;

  GetLocalPersonalAccountUsecase({required this.repository});

  Future<Either<AppFailure, PersonalAccountEntity?>> call() async {
    return await repository.getLocalPersonalAccount();
  }
}

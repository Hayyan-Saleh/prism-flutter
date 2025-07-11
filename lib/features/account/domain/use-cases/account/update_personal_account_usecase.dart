import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/account/domain/enitities/account/main/personal_account_entity.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class UpdatePersonalAccountUsecase {
  final AccountRepository repository;

  UpdatePersonalAccountUsecase({required this.repository});

  Future<Either<AppFailure, PersonalAccountEntity>> call({
    required File? profilePic,
    required PersonalAccountEntity personalAccount,
  }) async {
    return await repository.updatePersonalAccount(
      profilePic: profilePic,
      personalAccount: personalAccount,
    );
  }
}

import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class CreateStatusUseCase {
  final AccountRepository repository;

  CreateStatusUseCase({required this.repository});

  Future<Either<AccountFailure, Unit>> call({
    required String privacy,
    String? text,
    File? media,
  }) async {
    return await repository.createStatus(
      privacy: privacy,
      media: media,
      text: text,
    );
  }
}

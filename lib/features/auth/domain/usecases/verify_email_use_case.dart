import 'package:dartz/dartz.dart';
import 'package:realmo/core/failures/auth_failure.dart';

import '../repositories/auth_repository.dart';

class VerifyEmailUseCase {
  final AuthRepository repository;
  VerifyEmailUseCase(this.repository);

  Future<Either<AuthFailure, String>> call(String email) {
    return repository.verifyEmail(email);
  }
}

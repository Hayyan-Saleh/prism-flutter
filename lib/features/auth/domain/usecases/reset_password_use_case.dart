import 'package:dartz/dartz.dart';
import 'package:realmo/core/failures/auth_failure.dart';

import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;
  ResetPasswordUseCase(this.repository);

  Future<Either<AuthFailure, Unit>> call(String email, String newPassword) {
    return repository.resetPassword(email, newPassword);
  }
}

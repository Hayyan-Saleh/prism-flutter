import 'package:dartz/dartz.dart';
import 'package:realmo/core/failures/auth_failure.dart';

import '../repositories/auth_repository.dart';

class ForgetPasswordUseCase {
  final AuthRepository repository;
  ForgetPasswordUseCase(this.repository);

  Future<Either<AuthFailure, String>> call(String email) {
    return repository.forgetPassword(email);
  }
}

import 'package:dartz/dartz.dart';
import 'package:realmo/core/failures/auth_failure.dart';

import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;
  SignUpUseCase(this.repository);

  Future<Either<AuthFailure, Unit>> call(String firebaseIdToken) {
    return repository.signUp(firebaseIdToken);
  }
}

import 'package:dartz/dartz.dart';
import 'package:realmo/core/failures/auth_failure.dart';
import 'package:realmo/features/auth/domain/entities/user.dart';

import '../repositories/auth_repository.dart';

class GoogleLoginUseCase {
  final AuthRepository repository;
  GoogleLoginUseCase(this.repository);

  Future<Either<AuthFailure, UserEntity>> call(String firebaseIdToken) {
    return repository.googleLogin(firebaseIdToken);
  }
}

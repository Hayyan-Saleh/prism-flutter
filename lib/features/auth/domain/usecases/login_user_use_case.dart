// domain/usecases/login_with_email_use_case.dart

import 'package:dartz/dartz.dart';
import 'package:realmo/core/errors/failures/app_failure.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUserUseCase {
  final AuthRepository repository;

  const LoginUserUseCase({required this.repository});

  Future<Either<AppFailure, User>> call({
    required String email,
    required String password,
  }) {
    return repository.loginWithEmail(email: email, password: password);
  }
}

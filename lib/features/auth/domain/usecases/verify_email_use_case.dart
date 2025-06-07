import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import '../repositories/auth_repository.dart';

class VerifyEmailUseCase {
  final AuthRepository repository;

  const VerifyEmailUseCase({required this.repository});

  Future<Either<AppFailure, Unit>> call({
    required String email,
    required String code,
  }) async {
    return await repository.verifyEmail(email: email, code: code);
  }
}

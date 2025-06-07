import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import '../repositories/auth_repository.dart';

//Used to verify password reset code
class VerifyResetCodeUseCase {
  final AuthRepository repository;

  const VerifyResetCodeUseCase({required this.repository});

  Future<Either<AppFailure, Unit>> call({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    return await repository.verifyResetCode(email, code, newPassword);
  }
}

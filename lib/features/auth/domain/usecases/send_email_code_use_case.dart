import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import '../repositories/auth_repository.dart';

class SendEmailCodeUseCase {
  final AuthRepository repository;

  const SendEmailCodeUseCase({required this.repository});

  Future<Either<AppFailure, Unit>> call({
    required String email,
    required bool isReset,
  }) async {
    return await repository.sendEmailCode(email, isReset);
  }
}

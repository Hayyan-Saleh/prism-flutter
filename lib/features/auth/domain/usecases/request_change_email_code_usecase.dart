import 'package:dartz/dartz.dart';
import 'package:realmo/core/errors/failures/app_failure.dart';
import '../repositories/auth_repository.dart';

class RequestChangeEmailCodeUseCase {
  final AuthRepository repository;

  const RequestChangeEmailCodeUseCase({required this.repository});

  Future<Either<AppFailure, Unit>> call() async {
    return repository.requestChangeEmailCode();
  }
}

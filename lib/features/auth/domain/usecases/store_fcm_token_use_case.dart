import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/auth/domain/repositories/auth_repository.dart';

class StoreFcmTokenUseCase {
  final AuthRepository repository;

  StoreFcmTokenUseCase(this.repository);

  Future<Either<AppFailure, Unit>> call(String token) async {
    return await repository.storeFcmToken(token);
  }
}

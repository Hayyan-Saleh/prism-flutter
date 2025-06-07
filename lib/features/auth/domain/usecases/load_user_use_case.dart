import 'package:dartz/dartz.dart';
import 'package:realmo/core/errors/failures/app_failure.dart';

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoadUserUseCase {
  final AuthRepository repository;

  const LoadUserUseCase({required this.repository});

  Future<Either<AppFailure, User>> call() {
    return repository.loadUser();
  }
}

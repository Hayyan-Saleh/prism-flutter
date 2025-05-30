import 'package:dartz/dartz.dart';
import 'package:realmo/core/errors/failures/app_failure.dart';

import '../repositories/auth_repository.dart';

class LoadToken {
  final AuthRepository repository;

  LoadToken(this.repository);

  Future<Either<AppFailure, String?>> call() async {
    return await repository.loadToken();
  }
}

import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';

import '../repositories/auth_repository.dart';

class StoreToken {
  final AuthRepository repository;

  StoreToken(this.repository);

  Future<Either<AppFailure, Unit>> call(String newToken) async {
    return await repository.storeToken(newToken);
  }
}

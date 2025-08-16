import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';

import '../repositories/auth_repository.dart';

class DeleteToken {
  final AuthRepository repository;

  DeleteToken(this.repository);

  Future<Either<AppFailure, Unit>> call() async {
    return await repository.deleteToken();
  }
}

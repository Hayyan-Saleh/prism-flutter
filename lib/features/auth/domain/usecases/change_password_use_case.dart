import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures/app_failure.dart';
import '../repositories/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;

  const ChangePasswordUseCase({required this.repository});

  Future<Either<AppFailure, Unit>> call({
    required String oldPassword,
    required String newPassword,
  }) async {
    return repository.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }
}

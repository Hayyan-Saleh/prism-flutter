import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/auth/domain/entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GoogleSignInUseCase {
  final AuthRepository repository;

  const GoogleSignInUseCase({required this.repository});

  Future<Either<AppFailure, User>> call() async {
    return await repository.signInWithGoogle();
  }
}

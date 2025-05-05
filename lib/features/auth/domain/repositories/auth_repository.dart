import 'package:dartz/dartz.dart';
import 'package:realmo/core/failures/auth_failure.dart';
import 'package:realmo/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<AuthFailure, Unit>> signUp(String firebaseIdToken);
  Future<Either<AuthFailure, UserEntity>> passwordLogin(String firebaseIdToken);
  Future<Either<AuthFailure, UserEntity>> googleLogin(String firebaseIdToken);
  Future<Either<AuthFailure, String>> verifyEmail(
    String email,
  ); // returns 4-digit num
  Future<Either<AuthFailure, String>> forgetPassword(
    String email,
  ); // returns 4-digit num
  Future<Either<AuthFailure, Unit>> resetPassword(
    String email,
    String newPassword,
  );
}

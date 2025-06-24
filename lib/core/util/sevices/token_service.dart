// core/domain/services/token_service.dart
import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/core_failure.dart';
import 'package:prism/features/auth/domain/usecases/delete_token_use_case.dart';
import 'package:prism/features/auth/domain/usecases/load_token_use_case.dart';
import 'package:prism/features/auth/domain/usecases/store_token_use_case.dart';

abstract class TokenService {
  Future<Either<CoreFailure, String>> getToken();
  Future<Either<CoreFailure, Unit>> storeNewToken({required String newToken});
}

class TokenServiceImpl implements TokenService {
  final LoadToken loadToken;
  final StoreToken storeToken;
  final DeleteToken deleteToken;

  const TokenServiceImpl({
    required this.loadToken,
    required this.storeToken,
    required this.deleteToken,
  });

  @override
  Future<Either<CoreFailure, String>> getToken() async {
    final tokenResult = await loadToken();
    return tokenResult.fold(
      (failure) => Left(CoreFailure(failure.message)),
      (token) =>
          token != null
              ? Right(token)
              : Left(CoreFailure('No authentication token available')),
    );
  }

  @override
  Future<Either<CoreFailure, Unit>> storeNewToken({
    required String newToken,
  }) async {
    final tokenResult = await deleteToken();
    return tokenResult.fold((failure) => Left(CoreFailure(failure.message)), (
      _,
    ) async {
      final either = await storeToken(newToken);
      return either.fold(
        (failure) => Left(CoreFailure(failure.message)),
        (_) => Right(unit),
      );
    });
  }
}

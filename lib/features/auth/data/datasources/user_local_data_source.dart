import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prism/core/util/constants/strings.dart';

import '../../../../core/errors/failures/app_failure.dart';
import '../../../../core/errors/failures/cache_failure.dart';
import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<Either<AppFailure, Unit>> cacheUser(UserModel user);
  Future<Either<AppFailure, Unit>> cacheUserAsVerified();
  Future<Either<AppFailure, UserModel?>> loadUser();
  Future<Either<AppFailure, Unit>> cacheToken(String token);
  Future<Either<AppFailure, String?>> loadToken();
  Future<Either<AppFailure, Unit>> clearSession();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final FlutterSecureStorage secureStorage;
  String? _token;

  UserLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<Either<AppFailure, Unit>> cacheUser(UserModel user) async {
    try {
      final jsonString = jsonEncode(user.toJson());
      await secureStorage.write(key: USER_LOCAL_KEY, value: jsonString);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Failed to store user data: $e'));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> cacheUserAsVerified() async {
    try {
      final jsonString = await secureStorage.read(key: USER_LOCAL_KEY);
      if (jsonString == null) return const Right(unit);
      final Map<String, dynamic> map = jsonDecode(jsonString);
      final user = UserModel.fromJson(
        map,
        authType: map['authType'] as String,
        isEmailVerified: true,
      );
      await secureStorage.write(
        key: USER_LOCAL_KEY,
        value: jsonEncode(user.toJson()),
      );
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Failed to store user data: $e'));
    }
  }

  @override
  Future<Either<AppFailure, UserModel?>> loadUser() async {
    try {
      final jsonString = await secureStorage.read(key: USER_LOCAL_KEY);
      if (jsonString == null) return const Right(null);
      final Map<String, dynamic> map = jsonDecode(jsonString);
      final user = UserModel.fromJson(
        map,
        authType: map['authType'] as String,
        isEmailVerified: map['is_email_verified'] as bool,
      );
      return Right(user);
    } catch (e) {
      return Left(CacheFailure('Failed to fetch user data: $e'));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> cacheToken(String token) async {
    try {
      await secureStorage.write(key: TOKEN_LOCAL_KEY, value: token);
      _token = token; // Update in-memory cache
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Failed to store token: $e'));
    }
  }

  @override
  Future<Either<AppFailure, String?>> loadToken() async {
    if (_token != null) {
      return Right(_token);
    } else {
      try {
        final String? storedToken = await secureStorage.read(
          key: TOKEN_LOCAL_KEY,
        );
        _token = storedToken; // Assign to in-memory cache
        return Right(_token);
      } catch (e) {
        return Left(CacheFailure('Failed to fetch token: $e'));
      }
    }
  }

  @override
  Future<Either<AppFailure, Unit>> clearSession() async {
    try {
      await secureStorage.delete(key: USER_LOCAL_KEY);
      await secureStorage.delete(key: TOKEN_LOCAL_KEY);
      _token = null; // Clear in-memory token
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Failed to delete user data: $e'));
    }
  }
}

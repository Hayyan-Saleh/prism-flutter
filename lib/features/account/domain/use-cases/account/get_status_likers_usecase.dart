import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class GetStatusLikersUseCase {
  final AccountRepository repository;

  GetStatusLikersUseCase({required this.repository});

  Future<Either<AppFailure, List<SimplifiedAccountEntity>>> call(
    int params,
  ) async {
    return await repository.getStatusLikers(statusId: params);
  }
}

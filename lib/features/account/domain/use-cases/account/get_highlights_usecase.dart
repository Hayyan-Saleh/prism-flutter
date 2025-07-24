import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/enitities/account/highlight/highlight_entity.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class GetHighlightsUsecase {
  final AccountRepository repository;

  GetHighlightsUsecase({required this.repository});

  Future<Either<AccountFailure, List<HighlightEntity>>> call({int? accountId}) async {
    return await repository.getHighlights(accountId: accountId);
  }
}

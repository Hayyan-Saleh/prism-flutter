import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/enitities/account/highlight/detailed_highlight_entity.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class GetDetailedHighlightUsecase {
  final AccountRepository repository;

  GetDetailedHighlightUsecase({required this.repository});

  Future<Either<AccountFailure, DetailedHighlightEntity>> call({
    required int highlightId,
  }) async {
    return await repository.getDetailedHighlight(highlightId: highlightId);
  }
}

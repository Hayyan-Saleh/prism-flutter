import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class DeleteHighlightUseCase {
  final AccountRepository repository;

  DeleteHighlightUseCase({required this.repository});

  Future<Either<AccountFailure, Unit>> call({
    required int highlightId,
  }) async {
    return await repository.deleteHighlight(highlightId: highlightId);
  }
}

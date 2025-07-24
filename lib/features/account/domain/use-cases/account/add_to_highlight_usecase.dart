import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class AddToHighlightUseCase {
  final AccountRepository repository;

  AddToHighlightUseCase({required this.repository});

  Future<Either<AccountFailure, Unit>> call({
    required int highlightId,
    required int statusId,
  }) async {
    return await repository.addToHighlight(
      highlightId: highlightId,
      statusId: statusId,
    );
  }
}

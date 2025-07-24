import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class UpdateHighlightCoverUseCase {
  final AccountRepository repository;

  UpdateHighlightCoverUseCase({required this.repository});

  Future<Either<AccountFailure, Unit>> call({
    required int highlightId,
    required File cover,
  }) async {
    return await repository.updateHighlightCover(
      highlightId: highlightId,
      cover: cover,
    );
  }
}

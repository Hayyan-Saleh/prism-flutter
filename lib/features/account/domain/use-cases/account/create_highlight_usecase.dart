import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class CreateHighlightUseCase {
  final AccountRepository repository;

  CreateHighlightUseCase({required this.repository});

  Future<Either<AccountFailure, Unit>> call({
    required List<int> statusIds,
    String? text,
    File? cover,
  }) async {
    return await repository.createHighlight(
      statusIds: statusIds,
      text: text,
      cover: cover,
    );
  }
}

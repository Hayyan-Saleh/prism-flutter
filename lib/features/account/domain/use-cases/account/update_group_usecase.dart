import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class UpdateGroupUseCase {
  final AccountRepository repository;

  UpdateGroupUseCase({required this.repository});

  Future<Either<AccountFailure, Unit>> call({
    required int groupId,
    String? name,
    String? privacy,
    File? avatar,
    String? bio,
  }) {
    return repository.updateGroup(
      groupId: groupId,
      name: name,
      privacy: privacy,
      avatar: avatar,
      bio: bio,
    );
  }
}

import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/enitities/account/main/group_entity.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class CreateGroupUseCase {
  final AccountRepository repository;

  CreateGroupUseCase({required this.repository});

  Future<Either<AccountFailure, GroupEntity>> call({
    required String name,
    required String privacy,
    File? avatar,
    String? bio,
  }) {
    return repository.createGroup(
      name: name,
      privacy: privacy,
      avatar: avatar,
      bio: bio,
    );
  }
}

import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/repository/post_repository.dart';

class UpdatePostUseCase {
  final PostRepository repository;

  UpdatePostUseCase({required this.repository});

  Future<Either<AccountFailure, Unit>> call({
    required int postId,
    String? text,
    String? privacy,
    List<File>? mediaFiles,
    List<int>? removedMediaIds,
  }) async {
    return await repository.updatePost(
      postId: postId,
      text: text,
      privacy: privacy,
      mediaFiles: mediaFiles,
      removedMediaIds: removedMediaIds,
    );
  }
}

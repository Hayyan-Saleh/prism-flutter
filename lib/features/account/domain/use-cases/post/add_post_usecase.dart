
import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/repository/post_repository.dart';

class AddPostUseCase {
  final PostRepository repository;

  AddPostUseCase({required this.repository});

  Future<Either<AccountFailure, Unit>> call({
    required String? text,
    required String privacy,
    int? groupId,
    List<String>? mediaPaths,
  }) async {
    return await repository.addPost(
      text: text,
      privacy: privacy,
      groupId: groupId,
      mediaPaths: mediaPaths,
    );
  }
}
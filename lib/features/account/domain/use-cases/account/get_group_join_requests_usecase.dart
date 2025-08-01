import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/account/domain/enitities/notification/join_request_entity.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';

class GetGroupJoinRequestsUseCase {
  final AccountRepository repository;

  GetGroupJoinRequestsUseCase({required this.repository});

  Future<Either<AppFailure, List<JoinRequestEntity>>> call({
    required int groupId,
  }) async {
    return await repository.getGroupJoinRequests(groupId: groupId);
  }
}

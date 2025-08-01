import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/account/domain/repository/notification_repository.dart';

class RespondToJoinRequestUseCase {
  final NotificationRepository repository;

  RespondToJoinRequestUseCase({required this.repository});

  Future<Either<AppFailure, Unit>> call(
    RespondToJoinRequestParams params,
  ) async {
    return await repository.respondToJoinRequest(
      groupId: params.groupId,
      requestId: params.requestId,
      response: params.response,
      fromGroup: params.fromGroup,
    );
  }
}

class RespondToJoinRequestParams {
  final int groupId;
  final int requestId;
  final String response;
  final bool fromGroup;

  RespondToJoinRequestParams({
    required this.groupId,
    required this.requestId,
    required this.response,
    required this.fromGroup,
  });
}

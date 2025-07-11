import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/account/domain/repository/notification_repository.dart';

class RespondToFollowRequestUseCase {
  final NotificationRepository repository;

  RespondToFollowRequestUseCase({required this.repository});

  Future<Either<AppFailure, Unit>> call(
    RespondToFollowRequestParams params,
  ) async {
    return await repository.respondToFollowRequest(
      requestId: params.requestId,
      response: params.response,
    );
  }
}

class RespondToFollowRequestParams {
  final int requestId;
  final String response;

  RespondToFollowRequestParams({
    required this.requestId,
    required this.response,
  });
}

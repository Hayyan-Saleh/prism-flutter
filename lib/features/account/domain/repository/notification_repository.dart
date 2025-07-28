import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/account/domain/enitities/notification/follow_request_entity.dart';
import 'package:prism/features/account/domain/enitities/notification/join_request_entity.dart';

abstract class NotificationRepository {
  Future<Either<AppFailure, List<FollowRequestEntity>>> getFollowRequests();
  Future<Either<AppFailure, Unit>> respondToFollowRequest({
    required int requestId,
    required String response,
  });
  Future<Either<AppFailure, List<JoinRequestEntity>>> getJoinRequests();
  Future<Either<AppFailure, Unit>> respondToJoinRequest({
    required int groupId,
    required int requestId,
    required String response,
  });
}

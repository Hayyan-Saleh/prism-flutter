import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/account/domain/enitities/notification/follow_request_entity.dart';
import 'package:prism/features/account/domain/repository/notification_repository.dart';

class GetFollowRequestsUseCase {
  final NotificationRepository repository;

  GetFollowRequestsUseCase({required this.repository});

  Future<Either<AppFailure, List<FollowRequestEntity>>> call() async {
    return await repository.getFollowRequests();
  }
}

import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/account/domain/enitities/notification/join_request_entity.dart';
import 'package:prism/features/account/domain/repository/notification_repository.dart';

class GetJoinRequestsUseCase {
  final NotificationRepository repository;

  GetJoinRequestsUseCase({required this.repository});

  Future<Either<AppFailure, List<JoinRequestEntity>>> call() async {
    return await repository.getJoinRequests();
  }
}

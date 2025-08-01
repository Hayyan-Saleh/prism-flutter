import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/core/errors/failures/notification_failure.dart';
import 'package:prism/core/util/sevices/token_service.dart';
import 'package:prism/features/account/data/data-sources/notification_remote_data_source.dart';
import 'package:prism/features/account/domain/enitities/notification/follow_request_entity.dart';
import 'package:prism/features/account/domain/enitities/notification/join_request_entity.dart';
import 'package:prism/features/account/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  final TokenService tokenService;

  NotificationRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenService,
  });

  @override
  Future<Either<AppFailure, List<FollowRequestEntity>>>
      getFollowRequests() async {
    try {
      final tokenResult = await tokenService.getToken();
      return await tokenResult.fold((failure) => Left(failure), (token) async {
        final result = await remoteDataSource.getFollowRequests(token: token);
        return Right(result);
      });
    } catch (e) {
      return Left(NotificationFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> respondToFollowRequest({
    required int requestId,
    required String response,
  }) async {
    try {
      final tokenResult = await tokenService.getToken();
      return await tokenResult.fold((failure) => Left(failure), (token) async {
        await remoteDataSource.respondToFollowRequest(
          token: token,
          requestId: requestId,
          response: response,
        );
        return const Right(unit);
      });
    } catch (e) {
      return Left(NotificationFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<JoinRequestEntity>>> getJoinRequests() async {
    try {
      final tokenResult = await tokenService.getToken();
      return await tokenResult.fold((failure) => Left(failure), (token) async {
        final result = await remoteDataSource.getJoinRequests(token: token);
        return Right(result);
      });
    } catch (e) {
      return Left(NotificationFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> respondToJoinRequest({
    required int groupId,
    required int requestId,
    required String response,
    required bool fromGroup,
  }) async {
    try {
      final tokenResult = await tokenService.getToken();
      return await tokenResult.fold((failure) => Left(failure), (token) async {
        await remoteDataSource.respondToJoinRequest(
          token: token,
          groupId: groupId,
          requestId: requestId,
          response: response,
          fromGroup: fromGroup,
        );
        return const Right(unit);
      });
    } catch (e) {
      return Left(NotificationFailure(e.toString()));
    }
  }
}

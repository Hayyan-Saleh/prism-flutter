import 'package:prism/core/errors/exceptions/network_exception.dart';
import 'package:prism/core/errors/exceptions/server_exception.dart';
import 'package:prism/core/network/api_client.dart';
import 'package:prism/core/util/sevices/api_endpoints.dart';
import 'package:prism/features/account/data/models/notification/follow_request_model.dart';
import 'package:prism/core/errors/exceptions/account_exception.dart';
import 'package:prism/features/account/data/models/notification/join_request_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<FollowRequestModel>> getFollowRequests({required String token});
  Future<void> respondToFollowRequest({
    required String token,
    required int requestId,
    required String response,
  });
  Future<List<JoinRequestModel>> getJoinRequests({required String token});
  Future<void> respondToJoinRequest({
    required String token,
    required int groupId,
    required int requestId,
    required String response,
    required bool fromGroup,
  });
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient apiClient;

  NotificationRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<FollowRequestModel>> getFollowRequests({
    required String token,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.getFollowRequests,
        headers: _authHeaders(token),
      );
      final requests =
          (response['pending_requests'] as List)
              .map((data) => FollowRequestModel.fromJson(data))
              .toList();
      return requests;
    } on ServerException catch (e) {
      throw AccountException(e.message);
    } on NetworkException catch (e) {
      throw AccountException(e.message);
    }
  }

  @override
  Future<void> respondToFollowRequest({
    required String token,
    required int requestId,
    required String response,
  }) async {
    try {
      await apiClient.post(
        '${ApiEndpoints.respondToFollowRequest}/$requestId',
        {'state': response},
        headers: _authHeaders(token),
      );
    } on ServerException catch (e) {
      throw AccountException(e.message);
    } on NetworkException catch (e) {
      throw AccountException(e.message);
    }
  }

  @override
  Future<List<JoinRequestModel>> getJoinRequests({
    required String token,
  }) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.groups}/all-requests',
        headers: _authHeaders(token),
      );
      final requests =
          (response['requests'] as List)
              .map((data) => JoinRequestModel.fromJson(data))
              .toList();
      return requests;
    } on ServerException catch (e) {
      throw AccountException(e.message);
    } on NetworkException catch (e) {
      throw AccountException(e.message);
    }
  }

  @override
  Future<void> respondToJoinRequest({
    required String token,
    required int groupId,
    required int requestId,
    required String response,
    required bool fromGroup,
  }) async {
    try {
      final url = '${ApiEndpoints.groups}/$groupId/requests/respond';
      await apiClient.post(url, {
        'request_id': requestId,
        'state': response,
      }, headers: _authHeaders(token));
    } on ServerException catch (e) {
      throw AccountException(e.message);
    } on NetworkException catch (e) {
      throw AccountException(e.message);
    }
  }

  Map<String, String> _authHeaders(String token) => {
    'Authorization': 'Bearer $token',
  };
}

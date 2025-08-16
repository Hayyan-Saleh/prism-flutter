import 'package:prism/core/network/api_client.dart';
import 'package:prism/core/util/sevices/api_endpoints.dart';
import 'package:prism/features/account/data/models/global/follow_request_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<FollowRequestModel>> getFollowRequests({required String token});
  Future<void> respondToFollowRequest({
    required String token,
    required int requestId,
    required String response,
  });
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient apiClient;

  NotificationRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<FollowRequestModel>> getFollowRequests(
      {required String token}) async {
    final response = await apiClient.get(
      ApiEndpoints.getFollowRequests,
      headers: {'Authorization': 'Bearer $token'},
    );
    final requests = (response['pending_requests'] as List)
        .map((data) => FollowRequestModel.fromJson(data))
        .toList();
    return requests;
  }

  @override
  Future<void> respondToFollowRequest({
    required String token,
    required int requestId,
    required String response,
  }) async {
    await apiClient.post(
      '${ApiEndpoints.respondToFollowRequest}/$requestId',
      {'state': response},
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}

import 'package:prism/core/network/live_stream_api_client.dart';
import 'package:prism/features/live-stream/data/models/live_stream_model.dart';
import 'package:prism/core/util/sevices/token_service.dart';
import 'package:prism/features/live-stream/data/models/paginated_live_streams_model.dart';
import 'package:prism/core/util/sevices/api_endpoints.dart';

abstract class LiveStreamRemoteDataSource {
  Future<LiveStreamModel> startStream();
  Future<void> endStream(String streamKey);
  Future<PaginatedLiveStreamsModel> getActiveStreams(int page, int limit);
}

class LiveStreamRemoteDataSourceImpl implements LiveStreamRemoteDataSource {
  final LiveStreamApiClient apiClient;
  final TokenService tokenService;

  LiveStreamRemoteDataSourceImpl({
    required this.apiClient,
    required this.tokenService,
  });

  @override
  Future<LiveStreamModel> startStream() async {
    final tokenEither = await tokenService.getToken();
    return tokenEither.fold((failure) => throw failure, (token) async {
      final response = await apiClient.get(
        ApiEndpoints.startStream,
        headers: {'Authorization': 'Bearer $token'},
      );
      return LiveStreamModel.fromJson(response['stream']);
    });
  }

  @override
  Future<void> endStream(String streamKey) async {
    final tokenEither = await tokenService.getToken();
    return tokenEither.fold((failure) => throw failure, (token) async {
      await apiClient.get(
        ApiEndpoints.endStream(streamKey),
        headers: {'Authorization': 'Bearer $token'},
      );
    });
  }

  @override
  Future<PaginatedLiveStreamsModel> getActiveStreams(
    int page,
    int limit,
  ) async {
    final tokenEither = await tokenService.getToken();
    return tokenEither.fold((failure) => throw failure, (token) async {
      final response = await apiClient.get(
        '${ApiEndpoints.stream}?page=$page&limit=$limit',
        headers: {'Authorization': 'Bearer $token'},
      );
      return PaginatedLiveStreamsModel.fromJson(response);
    });
  }
}

import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/live-stream/domain/entities/live_stream_entity.dart';
import 'package:prism/features/live-stream/domain/entities/paginated_live_streams_entity.dart';

abstract class LiveStreamRepository {
  Future<Either<AppFailure, LiveStreamEntity>> startStream();
  Future<Either<AppFailure, void>> endStream(String streamKey);
  Future<Either<AppFailure, PaginatedLiveStreamsEntity>> getActiveStreams(
    int page,
    int limit,
  );
  Future<Either<AppFailure, void>> startStreaming(
    String streamUrl,
    CameraController cameraController,
  );
  Future<Either<AppFailure, void>> stopStreaming(
    CameraController? cameraController,
  );
}

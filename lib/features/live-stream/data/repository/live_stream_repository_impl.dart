import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/exceptions/network_exception.dart';
import 'package:prism/core/errors/exceptions/server_exception.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/core/errors/failures/network_failure.dart';
import 'package:prism/core/errors/failures/server_failure.dart';
import 'package:prism/features/live-stream/data/data-sources/live_stream_local_data_source.dart';
import 'package:prism/features/live-stream/data/data-sources/live_stream_remote_data_source.dart';
import 'package:prism/features/live-stream/domain/entities/live_stream_entity.dart';
import 'package:prism/features/live-stream/domain/entities/paginated_live_streams_entity.dart';
import 'package:prism/features/live-stream/domain/repository/live_stream_repository.dart';

class LiveStreamRepositoryImpl implements LiveStreamRepository {
  final LiveStreamRemoteDataSource remoteDataSource;
  final LiveStreamLocalDataSource localDataSource;

  LiveStreamRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<AppFailure, LiveStreamEntity>> startStream() async {
    try {
      final stream = await remoteDataSource.startStream();
      return Right(stream);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<AppFailure, void>> endStream(String streamKey) async {
    try {
      await remoteDataSource.endStream(streamKey);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<AppFailure, PaginatedLiveStreamsEntity>> getActiveStreams(
    int page,
    int limit,
  ) async {
    try {
      final streams = await remoteDataSource.getActiveStreams(page, limit);
      return Right(streams);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<AppFailure, void>> startStreaming(
    String streamUrl,
    CameraController cameraController,
  ) async {
    try {
      await localDataSource.startStreaming(streamUrl, cameraController);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> stopStreaming(
    CameraController? cameraController,
  ) async {
    try {
      await localDataSource.stopStreaming(cameraController);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }
}

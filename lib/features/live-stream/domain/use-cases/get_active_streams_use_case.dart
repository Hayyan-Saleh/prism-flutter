import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/live-stream/domain/entities/paginated_live_streams_entity.dart';
import 'package:prism/features/live-stream/domain/repository/live_stream_repository.dart';

class GetActiveStreamsUseCase {
  final LiveStreamRepository repository;

  GetActiveStreamsUseCase(this.repository);

  Future<Either<AppFailure, PaginatedLiveStreamsEntity>> call(
    int page,
    int limit,
  ) {
    return repository.getActiveStreams(page, limit);
  }
}

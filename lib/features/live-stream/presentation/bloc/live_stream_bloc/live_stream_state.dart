import 'package:equatable/equatable.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/live-stream/domain/entities/live_stream_entity.dart';
import 'package:prism/features/live-stream/domain/entities/paginated_live_streams_entity.dart';

abstract class LiveStreamState extends Equatable {
  const LiveStreamState();

  @override
  List<Object> get props => [];
}

class LiveStreamInitial extends LiveStreamState {}

class LiveStreamLoading extends LiveStreamState {}

class LiveStreamLoaded extends LiveStreamState {
  final PaginatedLiveStreamsEntity paginatedLiveStreams;

  const LiveStreamLoaded({required this.paginatedLiveStreams});

  @override
  List<Object> get props => [paginatedLiveStreams];
}

class LiveStreamStarted extends LiveStreamState {
  final LiveStreamEntity liveStream;

  const LiveStreamStarted({required this.liveStream});

  @override
  List<Object> get props => [liveStream];
}

class LiveStreamEnded extends LiveStreamState {}

class LiveStreamError extends LiveStreamState {
  final AppFailure failure;

  const LiveStreamError({required this.failure});

  @override
  List<Object> get props => [failure];
}

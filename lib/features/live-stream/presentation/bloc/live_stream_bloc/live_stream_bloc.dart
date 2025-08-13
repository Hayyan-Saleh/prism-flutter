import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/features/live-stream/domain/use-cases/end_stream_use_case.dart';
import 'package:prism/features/live-stream/domain/use-cases/get_active_streams_use_case.dart';
import 'package:prism/features/live-stream/domain/use-cases/start_stream_use_case.dart';
import 'package:prism/features/live-stream/presentation/bloc/live_stream_bloc/live_stream_event.dart';
import 'package:prism/features/live-stream/presentation/bloc/live_stream_bloc/live_stream_state.dart';

class LiveStreamBloc extends Bloc<LiveStreamEvent, LiveStreamState> {
  final GetActiveStreamsUseCase getActiveStreamsUseCase;
  final StartStreamUseCase startStreamUseCase;
  final EndStreamUseCase endStreamUseCase;

  LiveStreamBloc({
    required this.getActiveStreamsUseCase,
    required this.startStreamUseCase,
    required this.endStreamUseCase,
  }) : super(LiveStreamInitial()) {
    on<GetActiveStreamsEvent>((event, emit) async {
      emit(LiveStreamLoading());
      final failureOrStreams = await getActiveStreamsUseCase(
        event.page,
        event.limit,
      );
      failureOrStreams.fold(
        (failure) => emit(LiveStreamError(failure: failure)),
        (paginatedStreams) =>
            emit(LiveStreamLoaded(paginatedLiveStreams: paginatedStreams)),
      );
    });

    on<StartStreamEvent>((event, emit) async {
      emit(LiveStreamLoading());
      final failureOrStream = await startStreamUseCase();
      failureOrStream.fold(
        (failure) => emit(LiveStreamError(failure: failure)),
        (stream) => emit(LiveStreamStarted(liveStream: stream)),
      );
    });

    on<EndStreamEvent>((event, emit) async {
      emit(LiveStreamLoading());
      final failureOrVoid = await endStreamUseCase(event.streamKey);
      failureOrVoid.fold(
        (failure) => emit(LiveStreamError(failure: failure)),
        (_) => emit(LiveStreamEnded()),
      );
    });
  }
}

import 'package:equatable/equatable.dart';

abstract class LiveStreamEvent extends Equatable {
  const LiveStreamEvent();

  @override
  List<Object> get props => [];
}

class GetActiveStreamsEvent extends LiveStreamEvent {
  final int page;
  final int limit;

  const GetActiveStreamsEvent({required this.page, required this.limit});

  @override
  List<Object> get props => [page, limit];
}

class StartStreamEvent extends LiveStreamEvent {}

class EndStreamEvent extends LiveStreamEvent {
  final String streamKey;

  const EndStreamEvent({required this.streamKey});

  @override
  List<Object> get props => [streamKey];
}

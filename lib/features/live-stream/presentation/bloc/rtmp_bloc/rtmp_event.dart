part of 'rtmp_bloc.dart';

sealed class RtmpEvent extends Equatable {
  const RtmpEvent();

  @override
  List<Object> get props => [];
}

class InitializeCameraEvent extends RtmpEvent {
  final CameraDescription cameraDescription;
  final bool enableAudio;

  const InitializeCameraEvent(
      {required this.cameraDescription, required this.enableAudio});

  @override
  List<Object> get props => [cameraDescription, enableAudio];
}

class LoadCamerasEvent extends RtmpEvent {}

class StartStreamingEvent extends RtmpEvent {
  final String streamUrl;

  const StartStreamingEvent({required this.streamUrl});

  @override
  List<Object> get props => [streamUrl];
}

class StopStreamingEvent extends RtmpEvent {}

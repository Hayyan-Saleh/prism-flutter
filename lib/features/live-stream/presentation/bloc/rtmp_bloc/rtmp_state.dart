part of 'rtmp_bloc.dart';

abstract class RtmpState extends Equatable {
  const RtmpState();

  @override
  List<Object> get props => [];
}

class RtmpInitial extends RtmpState {
  const RtmpInitial();
}

class RtmpLoading extends RtmpState {
  const RtmpLoading();
}

class CamerasLoaded extends RtmpState {
  final List<CameraDescription> cameras;

  const CamerasLoaded({required this.cameras});

  @override
  List<Object> get props => [cameras];
}

class RtmpCameraInitialized extends RtmpState {
  final CameraController controller;

  const RtmpCameraInitialized({required this.controller});

  @override
  List<Object> get props => [controller];
}

class RtmpStreaming extends RtmpState {
  const RtmpStreaming();
}

class RtmpStopped extends RtmpState {
  const RtmpStopped();
}

class RtmpError extends RtmpState {
  final String message;

  const RtmpError({required this.message});

  @override
  List<Object> get props => [message];
}
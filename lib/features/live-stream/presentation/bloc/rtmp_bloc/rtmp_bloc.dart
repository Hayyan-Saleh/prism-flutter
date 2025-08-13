import 'dart:io';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prism/features/live-stream/domain/use-cases/start_streaming_use_case.dart';
import 'package:prism/features/live-stream/domain/use-cases/stop_streaming_use_case.dart';

part 'rtmp_event.dart';
part 'rtmp_state.dart';

class RtmpBloc extends Bloc<RtmpEvent, RtmpState> {
  final StartStreamingUseCase startStreamingUseCase;
  final StopStreamingUseCase stopStreamingUseCase;
  CameraController? _cameraController;

  CameraController? get cameraController => _cameraController;

  RtmpBloc({
    required this.startStreamingUseCase,
    required this.stopStreamingUseCase,
  }) : super(const RtmpInitial()) {
    on<InitializeCameraEvent>(_onInitializeCamera);
    on<StartStreamingEvent>(_onStartStreaming);
    on<StopStreamingEvent>(_onStopStreaming);
    on<LoadCamerasEvent>(_onLoadCameras);
  }

  @override
  Future<void> close() {
    _cameraController?.dispose();
    return super.close();
  }

  Future<void> _onLoadCameras(
    LoadCamerasEvent event,
    Emitter<RtmpState> emit,
  ) async {
    emit(const RtmpLoading());
    try {
      if (!await Permission.camera.request().isGranted ||
          !await Permission.microphone.request().isGranted) {
        throw Exception("Camera or microphone permission denied.");
      }
      final cameras = await availableCameras();
      emit(CamerasLoaded(cameras: cameras));
    } catch (e) {
      emit(RtmpError(message: e.toString()));
    }
  }

  Future<void> _onInitializeCamera(
    InitializeCameraEvent event,
    Emitter<RtmpState> emit,
  ) async {
    emit(const RtmpLoading());
    try {
      _cameraController = CameraController(
        event.cameraDescription,
        ResolutionPreset.low,
        enableAudio: event.enableAudio,
        imageFormatGroup:
            Platform.isAndroid
                ? ImageFormatGroup.yuv420
                : ImageFormatGroup.bgra8888,
      );

      await _cameraController!.initialize();
      emit(RtmpCameraInitialized(controller: _cameraController!));
    } catch (e) {
      emit(RtmpError(message: e.toString()));
    }
  }

  Future<void> _onStartStreaming(
    StartStreamingEvent event,
    Emitter<RtmpState> emit,
  ) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      emit(const RtmpError(message: 'Camera is not ready.'));
      return;
    }
    final result = await startStreamingUseCase(
      event.streamUrl,
      _cameraController!,
    );
    result.fold(
      (failure) => emit(RtmpError(message: failure.message)),
      (_) => emit(const RtmpStreaming()),
    );
  }

  Future<void> _onStopStreaming(
    StopStreamingEvent event,
    Emitter<RtmpState> emit,
  ) async {
    final result = await stopStreamingUseCase(_cameraController);
    await _cameraController?.dispose();
    _cameraController = null;
    result.fold(
      (failure) => emit(RtmpError(message: failure.message)),
      (_) => emit(const RtmpStopped()),
    );
  }
}

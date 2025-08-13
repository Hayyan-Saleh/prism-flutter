import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:record/record.dart';

class FfmpegService {
  bool _isStreaming = false;

  // Video pipe
  String? _videoPipePath;
  IOSink? _videoPipeSink;

  // Audio pipe
  String? _audioPipePath;
  IOSink? _audioPipeSink;

  // Audio recorder
  final AudioRecorder _audioRecorder = AudioRecorder();

  Future<void> startStreaming(
    String streamUrl,
    CameraController cameraController,
  ) async {
    if (!cameraController.value.isInitialized) {
      return;
    }
    if (_isStreaming) {
      return;
    }

    try {
      _isStreaming = true;
      _videoPipePath = await FFmpegKitConfig.registerNewFFmpegPipe();
      if (cameraController.enableAudio) {
        _audioPipePath = await FFmpegKitConfig.registerNewFFmpegPipe();
      }

      if (_videoPipePath == null ||
          (cameraController.enableAudio && _audioPipePath == null)) {
        throw Exception("Failed to create FFmpeg pipes.");
      }

      final videoPipeFile = File(_videoPipePath!);
      _videoPipeSink = videoPipeFile.openWrite();

      if (cameraController.enableAudio) {
        final audioPipeFile = File(_audioPipePath!);
        _audioPipeSink = audioPipeFile.openWrite();
      }

      final resolution = cameraController.value.previewSize!;
      final width = resolution.width.toInt();
      final height = resolution.height.toInt();
      final fps = 30;

      // Determine the correct rotation based on the camera type
      String rotationFilter = '';
      if (cameraController.description.lensDirection ==
          CameraLensDirection.front) {
        rotationFilter = 'hflip,transpose=1';
      } else {
        rotationFilter = 'transpose=1';
      }

      // Chain the filters together.
      final filterChain =
          'colormatrix=bt601:bt709${rotationFilter.isNotEmpty ? ',$rotationFilter' : ''}';

      final command =
          cameraController.enableAudio
              ? '-itsoffset 25 -f rawvideo -vcodec rawvideo -pix_fmt yuv420p -s ${width}x$height -r $fps -i $_videoPipePath '
                  '-f s16le -ar 44100 -ac 1 -i $_audioPipePath '
                  '-map 0:v:0 -map 1:a:0 '
                  '-vf "$filterChain" '
                  '-c:v libx264 -tune zerolatency -b:v 400k -maxrate 600k -bufsize 800k '
                  '-c:a aac -b:a 32k -ar 44100 '
                  '-f flv "$streamUrl"'
              : '-f rawvideo -vcodec rawvideo -pix_fmt yuv420p -s ${width}x$height -r $fps -i $_videoPipePath '
                  '-map 0:v:0 '
                  '-vf "$filterChain" '
                  '-c:v libx264 -tune zerolatency -b:v 400k -maxrate 600k -bufsize 800k '
                  '-an '
                  '-f flv "$streamUrl"';

      FFmpegKit.executeAsync(command, (session) async {
        final returnCode = await session.getReturnCode();
        if (ReturnCode.isSuccess(returnCode)) {
        } else if (ReturnCode.isCancel(returnCode)) {}
        _isStreaming = false;
        await _videoPipeSink?.close();
        _videoPipeSink = null;
        await _audioPipeSink?.close();
        _audioPipeSink = null;
      });

      cameraController.startImageStream((CameraImage image) {
        if (_isStreaming) {
          _writeFrameToVideoPipe(image);
        }
      });

      if (cameraController.enableAudio) {
        if (await _audioRecorder.hasPermission()) {
          final audioStream = await _audioRecorder.startStream(
            const RecordConfig(
              encoder: AudioEncoder.pcm16bits,
              sampleRate: 44100,
              numChannels: 1,
            ),
          );
          audioStream.listen(
            (data) {
              if (_isStreaming && _audioPipeSink != null) {
                _audioPipeSink!.add(data);
              }
            },
            onError: (error) {},
            onDone: () {},
          );
        } else {
          throw Exception(
            'Audio permission not granted. Please enable it in your device settings to stream with audio.',
          );
        }
      }
    } catch (e) {
      _isStreaming = false;
      await _videoPipeSink?.close();
      _videoPipeSink = null;
      await _audioPipeSink?.close();
      _audioPipeSink = null;
      rethrow;
    }
  }

  void _writeFrameToVideoPipe(CameraImage image) {
    if (_videoPipeSink == null) return;
    if (Platform.isAndroid) {
      final yPlane = image.planes[0];
      final uPlane = image.planes[1];
      final vPlane = image.planes[2];

      final int width = image.width;
      final int height = image.height;

      // Check if the resolution is valid
      if (width % 2 != 0 || height % 2 != 0) {
        return;
      }

      final yuv420pSize =
          width * height + (width * height ~/ 4) + (width * height ~/ 4);
      final yuv420pBytes = Uint8List(yuv420pSize);
      int yuvIndex = 0;

      // Copy Y plane data, handling bytesPerRow padding
      final int yWidth = yPlane.bytesPerRow;
      for (int i = 0; i < height; i++) {
        final yRowStart = i * yWidth;
        yuv420pBytes.setAll(
          yuvIndex,
          yPlane.bytes.sublist(yRowStart, yRowStart + width),
        );
        yuvIndex += width;
      }

      // Check for planar YUV (emulator) vs interleaved UV (physical device)
      if (uPlane.bytesPerPixel == 1 && vPlane.bytesPerPixel == 1) {
        // This is a typical planar YUV420P or similar (e.g., emulator)
        final int uBytesPerRow = uPlane.bytesPerRow;
        final int vBytesPerRow = vPlane.bytesPerRow;
        final int uvHeight = height ~/ 2;
        final int uvWidth = width ~/ 2;

        // Copy U plane
        for (int i = 0; i < uvHeight; i++) {
          final uRowStart = i * uBytesPerRow;
          yuv420pBytes.setAll(
            yuvIndex,
            uPlane.bytes.sublist(uRowStart, uRowStart + uvWidth),
          );
          yuvIndex += uvWidth;
        }

        // Copy V plane
        for (int i = 0; i < uvHeight; i++) {
          final vRowStart = i * vBytesPerRow;
          yuv420pBytes.setAll(
            yuvIndex,
            vPlane.bytes.sublist(vRowStart, vRowStart + uvWidth),
          );
          yuvIndex += uvWidth;
        }
      } else if (uPlane.bytesPerPixel == 2) {
        // This is the interleaved UV case (NV21/NV12)
        final uvBytes = uPlane.bytes;
        final int uvBytesPerRow = uPlane.bytesPerRow;
        final int uvHeight = height ~/ 2;
        final int uvPixelWidth = width ~/ 2;

        // Calculate the total size of the interleaved UV buffer to avoid out-of-bounds access.
        // The `length` property is the most reliable way to get the actual size.
        final int uvPlaneSize = uPlane.bytes.length;

        // Extract and copy U values
        // We must check our calculated index against the buffer's actual length.
        for (int i = 0; i < uvHeight; i++) {
          for (int j = 0; j < uvPixelWidth; j++) {
            final int sourceIndex = i * uvBytesPerRow + j * 2;
            if (sourceIndex < uvPlaneSize) {
              yuv420pBytes[yuvIndex++] = uvBytes[sourceIndex];
            } else {
              // Fill the rest with a default value to prevent crash
              yuv420pBytes[yuvIndex++] = 128; // Default to mid-gray for U/V
              // And break out of the loop
              break;
            }
          }
        }

        // Extract and copy V values
        for (int i = 0; i < uvHeight; i++) {
          for (int j = 0; j < uvPixelWidth; j++) {
            final int sourceIndex = i * uvBytesPerRow + j * 2 + 1;
            if (sourceIndex < uvPlaneSize) {
              yuv420pBytes[yuvIndex++] = uvBytes[sourceIndex];
            } else {
              yuv420pBytes[yuvIndex++] = 128; // Default to mid-gray
              break;
            }
          }
        }
      } else {
        return;
      }

      _videoPipeSink!.add(yuv420pBytes);
    } else {
      _videoPipeSink!.add(image.planes[0].bytes);
    }
  }

  Future<void> stopStreaming(CameraController? cameraController) async {
    if (!_isStreaming) {
      return;
    }
    try {
      if (cameraController != null &&
          cameraController.value.isStreamingImages) {
        await cameraController.stopImageStream();
      }

      if (await _audioRecorder.isRecording()) {
        await _audioRecorder.stop();
      }

      await FFmpegKit.cancel();
      _isStreaming = false;
    } catch (e) {
      rethrow;
    }
  }
}

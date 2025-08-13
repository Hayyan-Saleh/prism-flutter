import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/features/live-stream/presentation/bloc/live_stream_bloc/live_stream_bloc.dart';
import 'package:prism/features/live-stream/presentation/bloc/live_stream_bloc/live_stream_event.dart';
import 'package:prism/features/live-stream/presentation/bloc/live_stream_bloc/live_stream_state.dart';
import 'package:prism/features/live-stream/presentation/bloc/rtmp_bloc/rtmp_bloc.dart';

class CreateLiveStreamPage extends StatefulWidget {
  const CreateLiveStreamPage({super.key});

  @override
  State<CreateLiveStreamPage> createState() => _CreateLiveStreamPageState();
}

enum _SetupStep { initial, selectCamera, enableAudio, finalStep }

class _CreateLiveStreamPageState extends State<CreateLiveStreamPage> {
  _SetupStep _currentStep = _SetupStep.initial;
  double _backgroundWidth = 0;
  bool _isAnimating = true;

  CameraDescription? _selectedCamera;
  bool _enableAudio = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _backgroundWidth = getWidth(context);
      });
    });
  }

  void _goToNextStep() {
    setState(() {
      _isAnimating = true;
      _backgroundWidth = 0;
    });
  }

  void _onAnimationEnd() {
    if (_backgroundWidth == 0) {
      setState(() {
        if (_currentStep == _SetupStep.initial) {
          _currentStep = _SetupStep.selectCamera;
          context.read<RtmpBloc>().add(LoadCamerasEvent());
        } else if (_currentStep == _SetupStep.selectCamera) {
          _currentStep = _SetupStep.enableAudio;
        } else if (_currentStep == _SetupStep.enableAudio) {
          _currentStep = _SetupStep.finalStep;
        }
        _backgroundWidth = getWidth(context);
      });
    } else {
      setState(() {
        _isAnimating = false;
      });
    }
  }

  @override //
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.pink.withAlpha(150),
        body: Center(
          child: ClipRect(
            child: OverflowBox(
              maxHeight: double.infinity,
              maxWidth: double.infinity,
              child: Transform.rotate(
                angle: math.pi / 4,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  color: Theme.of(context).primaryColor,
                  height: 2 * getHeight(context),
                  width: _backgroundWidth,
                  onEnd: _onAnimationEnd,
                  child:
                      _isAnimating
                          ? const SizedBox()
                          : Transform.rotate(
                            angle: -math.pi / 4,
                            child: ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black,
                                    Colors.black,
                                    Colors.transparent,
                                  ],
                                  stops: [0.0, 0.1, 0.9, 1.0],
                                ).createShader(bounds);
                              },
                              blendMode: BlendMode.dstIn,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: _buildStepContent(),
                              ),
                            ),
                          ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case _SetupStep.initial:
        return _buildInitialStep();
      case _SetupStep.selectCamera:
        return _buildSelectCameraStep();
      case _SetupStep.enableAudio:
        return _buildEnableAudioStep();
      case _SetupStep.finalStep:
        return _buildFinalStep();
    }
  }

  Widget _buildInitialStep() {
    final double ratio = getAR(context);
    return Center(
      key: const ValueKey('initial'),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)?.readyToStream ??
                  'Ready to start your live stream?',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            AppButton(
              onPressed: _goToNextStep,
              bgColor: Colors.pink,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.videocam, size: 75 * ratio, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)?.letsStart ?? 'Let\'s Start',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectCameraStep() {
    return Center(
      key: const ValueKey('selectCamera'),
      child: BlocConsumer<RtmpBloc, RtmpState>(
        listener: (context, state) {
          if (state is CamerasLoaded && state.cameras.isNotEmpty) {
            setState(() {
              _selectedCamera = state.cameras.first;
            });
          }
        },
        builder: (context, state) {
          if (state is RtmpLoading) {
            return CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onPrimary,
            );
          }
          if (state is RtmpError) {
            return Text(
              state.message,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            );
          }
          if (state is CamerasLoaded) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.selectCamera,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                ...state.cameras.map((camera) {
                  return RadioListTile<CameraDescription>(
                    title: Text(
                      '${camera.name} (${camera.lensDirection.toString().split('.').last})',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    value: camera,
                    groupValue: _selectedCamera,
                    onChanged: (value) {
                      setState(() {
                        _selectedCamera = value;
                      });
                    },
                    activeColor: Colors.pink,
                  );
                }),
                SizedBox(height: 20),
                AppButton(
                  onPressed: _selectedCamera == null ? () {} : _goToNextStep,
                  bgColor: Colors.pink,
                  child: Text(
                    AppLocalizations.of(context)!.next,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          }
          return Text(
            AppLocalizations.of(context)!.initializing,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          );
        },
      ),
    );
  }

  Widget _buildEnableAudioStep() {
    return Center(
      key: const ValueKey('enableAudio'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.enableAudio,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: _enableAudio,
                  onChanged: (value) {
                    setState(() {
                      _enableAudio = value;
                    });
                  },
                  activeColor: Colors.pink,
                ),
              ],
            ),
            const SizedBox(height: 20),
            AppButton(
              onPressed: _goToNextStep,
              bgColor: Colors.pink,
              child: Text(
                AppLocalizations.of(context)!.next,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalStep() {
    return BlocListener<LiveStreamBloc, LiveStreamState>(
      key: const ValueKey('finalStep'),
      listener: (context, state) {
        if (state is LiveStreamStarted) {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.myLiveStream,
            arguments: {
              'stream': state.liveStream,
              'cameraDescription': _selectedCamera!,
              'enableAudio': _enableAudio,
            },
          );
        }
        if (state is LiveStreamError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.failure.message)));
        }
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.readyToGo,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<LiveStreamBloc, LiveStreamState>(
              builder: (context, state) {
                if (state is LiveStreamLoading) {
                  return CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onPrimary,
                  );
                }
                return AppButton(
                  onPressed: () {
                    context.read<LiveStreamBloc>().add(StartStreamEvent());
                  },
                  bgColor: Colors.green,
                  child: Text(
                    AppLocalizations.of(context)!.startLiveStream,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

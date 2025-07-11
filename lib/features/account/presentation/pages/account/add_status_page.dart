import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prism/core/util/entities/media_entity.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/features/account/presentation/bloc/account/status_bloc/status_bloc.dart';
import 'package:prism/features/account/presentation/widgets/gallery_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddStatusPage extends StatefulWidget {
  const AddStatusPage({super.key});

  @override
  AddStatusPageState createState() => AddStatusPageState();
}

class AddStatusPageState extends State<AddStatusPage> {
  final PageController _pageController = PageController();
  String? _selectedOption;
  File? _selectedMedia;
  MediaType? _mediaType;
  final GlobalKey<FormState> _textFormKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  bool _showToggle = false;
  bool _statusPrivacy = false;
  BetterPlayerController? _videoController;
  double _uploadProgress = 0.0;

  @override
  void dispose() {
    _videoController?.dispose();
    _pageController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _navigateToNextPage(String option) {
    _selectedOption = option;
    _showToggle = true;
    setState(() {});
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onMediaSelected(File file, MediaType type) {
    setState(() {
      _selectedMedia = file;
      _mediaType = type;
      if (_mediaType == MediaType.video) {
        _videoController?.dispose();
        _videoController = BetterPlayerController(
          BetterPlayerConfiguration(
            autoPlay: false,
            aspectRatio: 16 / 9,
            errorBuilder:
                (context, errorMessage) => Center(
                  child: Text(
                    AppLocalizations.of(
                      context,
                    )!.errorLoadingVideo(errorMessage ?? ''),
                  ),
                ),
          ),
          betterPlayerDataSource: BetterPlayerDataSource(
            BetterPlayerDataSourceType.file,
            file.path,
            cacheConfiguration: const BetterPlayerCacheConfiguration(
              useCache: true,
              maxCacheSize: 10 * 1024 * 1024,
              maxCacheFileSize: 10 * 1024 * 1024,
            ),
          ),
        );
      } else {
        _videoController?.dispose();
        _videoController = null;
      }
    });
    _navigateToNextPage(type.name);
  }

  Future<bool> _requestCameraPermission() async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      status = await Permission.camera.request();
    } else {
      status = await Permission.camera.request();
    }
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
    return false;
  }

  void _pickFromCamera(bool isVideo) async {
    if (await _requestCameraPermission()) {
      final picker = ImagePicker();
      final picked =
          isVideo
              ? await picker.pickVideo(source: ImageSource.camera)
              : await picker.pickImage(source: ImageSource.camera);
      if (picked != null) {
        setState(() {
          _selectedMedia = File(picked.path);
          _mediaType = isVideo ? MediaType.video : MediaType.image;
          if (_mediaType == MediaType.video) {
            _videoController?.dispose();
            _videoController = BetterPlayerController(
              BetterPlayerConfiguration(
                autoPlay: false,
                aspectRatio: 16 / 9,
                errorBuilder:
                    (context, errorMessage) => Center(
                      child: Text(
                        AppLocalizations.of(
                          context,
                        )!.errorLoadingVideo(errorMessage ?? ''),
                      ),
                    ),
              ),
              betterPlayerDataSource: BetterPlayerDataSource(
                BetterPlayerDataSourceType.file,
                picked.path,
                cacheConfiguration: const BetterPlayerCacheConfiguration(
                  useCache: true,
                  maxCacheSize: 10 * 1024 * 1024,
                  maxCacheFileSize: 10 * 1024 * 1024,
                ),
              ),
            );
          } else {
            _videoController?.dispose();
            _videoController = null;
          }
          _navigateToNextPage(_mediaType?.name ?? 'text');
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.cameraAccessDenied),
          ),
        );
      }
    }
  }

  void _submitStatus() {
    // Go to next page
    _showToggle = false;
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    // trigger bloc event
    final String privacy = _statusPrivacy ? 'private' : 'public';

    if (_selectedOption == 'text' &&
        _textFormKey.currentState?.validate() == true) {
      context.read<StatusBloc>().add(
        CreateStatusEvent(privacy: privacy, text: _textController.text.trim()),
      );
    } else {
      context.read<StatusBloc>().add(
        CreateStatusEvent(
          privacy: privacy,
          media: _selectedMedia,
          text: _textController.text.trim(),
        ),
      );
    }
    // add simulation
    _simulateUpload();
  }

  void _simulateUpload() async {
    for (int i = 0; i < 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _uploadProgress = i / 100;
      });
    }
  }

  Widget _wrapWithBlocListener({required Widget child}) {
    return BlocListener<StatusBloc, StatusState>(
      listener: (context, state) async {
        if (state is StatusCreated) {
          _uploadProgress = 1;
          await Future.delayed(Duration(seconds: 1));
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        } else if (state is StatusFailure) {
          showCustomAboutDialog(
            context,
            AppLocalizations.of(context)!.error,
            state.error,
            null,
            true,
          );
        }
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _wrapWithBlocListener(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildFirstPage(context),
            _buildSecondPage(context),
            _buildThirdPage(context),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      actions: _showToggle ? [_buildPrivacyToggle()] : null,
    );
  }

  Widget _buildPrivacyToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        spacing: 20,
        children: [
          Text(
            AppLocalizations.of(context)!.privacy,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(
            height: 32,
            child: Switch(
              trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                return Theme.of(context).colorScheme.secondary.withAlpha(150);
              }),
              value: _statusPrivacy,
              onChanged: (value) => setState(() => _statusPrivacy = value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildP1FirstSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                AppButton(
                  onPressed: () => _navigateToNextPage('text'),
                  child: Text(AppLocalizations.of(context)!.textOnly),
                ),
                AppButton(
                  onPressed: () => _pickFromCamera(false),
                  child: Text(AppLocalizations.of(context)!.cameraImage),
                ),
                AppButton(
                  onPressed: () => _pickFromCamera(true),
                  child: Text(AppLocalizations.of(context)!.cameraVideo),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstPage(BuildContext context) {
    return Column(
      children: [
        _buildP1FirstSection(),
        Expanded(child: GalleryWidget(onMediaSelected: _onMediaSelected)),
      ],
    );
  }

  Widget _buildTextWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _textFormKey,
          child: TextFormField(
            controller: _textController,
            validator: (val) {
              if (val == null || val == '') {
                return AppLocalizations.of(context)!.addStatusDetails;
              }
              return null;
            },
            maxLines: null,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.enterYourStatus,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondPage(BuildContext context) {
    return Column(
      children: [
        if (_selectedMedia != null)
          Expanded(
            child:
                _mediaType == MediaType.image
                    ? Image.file(_selectedMedia!, fit: BoxFit.contain)
                    : _buildVideoPlayer(),
          ),
        _selectedMedia != null
            ? _buildTextWidget()
            : Expanded(child: _buildTextWidget()),
        Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 128,
                ),
                height: 48,
                child: AppButton(
                  onPressed: () {
                    switch (_selectedOption) {
                      case 'text':
                        {
                          if (_textController.text.isNotEmpty) {
                            _submitStatus();
                          }
                        }
                        break;
                      case 'image':
                        _selectedMedia != null ? _submitStatus() : null;
                        break;
                      case 'video':
                        _selectedMedia != null ? _submitStatus() : null;
                        break;
                    }
                  },
                  child: Center(
                    child: Icon(Icons.navigate_next_sharp, size: 32),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    if (_videoController == null) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noVideoAvailable),
      );
    }
    return BetterPlayer(controller: _videoController!);
  }

  Widget _buildThirdPage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(value: _uploadProgress),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.uploading(_uploadProgress * 100),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

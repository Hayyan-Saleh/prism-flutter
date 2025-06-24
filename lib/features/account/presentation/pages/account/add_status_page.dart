import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/di/injection_container.dart';
import 'package:prism/core/util/entities/media_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/status_bloc/status_bloc.dart';
import 'package:prism/features/account/presentation/widgets/gallery_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';

class AddStatusPage extends StatefulWidget {
  const AddStatusPage({super.key});

  @override
  _AddStatusPageState createState() => _AddStatusPageState();
}

class _AddStatusPageState extends State<AddStatusPage> {
  final PageController _pageController = PageController();
  String? _selectedOption; // text, image, video
  File? _selectedMedia;
  MediaType? _mediaType;
  final TextEditingController _textController = TextEditingController();
  double _uploadProgress = 0.0; // Simulated upload progress

  @override
  void dispose() {
    _pageController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _navigateToNextPage(String option) {
    setState(() {
      _selectedOption = option;
      _selectedMedia = null; // Reset media for new selection
    });
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
    });
  }

  void _pickFromCamera(bool isVideo) async {
    final picker = ImagePicker();
    final picked =
        isVideo
            ? await picker.pickVideo(source: ImageSource.camera)
            : await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _selectedMedia = File(picked.path);
        _mediaType = isVideo ? MediaType.video : MediaType.image;
      });
    }
  }

  void _submitStatus() {
    // Simulate upload
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _simulateUpload();
  }

  void _simulateUpload() async {
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _uploadProgress = i / 100;
      });
    }
    // Navigate back or show success
    if (mounted) Navigator.pop(context);
  }

  Widget _wrapWithBloc({required Widget child}) {
    return BlocProvider<StatusBloc>(
      create: (context) => sl<StatusBloc>(),
      child: BlocListener<StatusBloc, StatusState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _wrapWithBloc(
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Status')),
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

  Widget _buildFirstPage(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _navigateToNextPage('text'),
                child: const Text('Text Only'),
              ),
              ElevatedButton(
                onPressed: () => _navigateToNextPage('image'),
                child: const Text('Image + Text'),
              ),
              ElevatedButton(
                onPressed: () => _navigateToNextPage('video'),
                child: const Text('Video + Text'),
              ),
            ],
          ),
        ),
        Expanded(child: GalleryWidget(onMediaSelected: _onMediaSelected)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _pickFromCamera(false),
              child: const Text('Camera Image'),
            ),
            ElevatedButton(
              onPressed: () => _pickFromCamera(true),
              child: const Text('Camera Video'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecondPage(BuildContext context) {
    if (_selectedOption == 'text') {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
            controller: _textController,
            maxLines: null,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24),
            decoration: const InputDecoration(
              hintText: 'Enter your status...',
              border: InputBorder.none,
            ),
          ),
        ),
      );
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _textController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Add optional text...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child:
                _selectedMedia == null
                    ? const Center(child: Text('No media selected'))
                    : _mediaType == MediaType.image
                    ? Image.file(_selectedMedia!, fit: BoxFit.contain)
                    : _buildVideoPlayer(),
          ),
          ElevatedButton(
            onPressed:
                _selectedMedia != null || _textController.text.isNotEmpty
                    ? _submitStatus
                    : null,
            child: const Text('Submit'),
          ),
        ],
      );
    }
  }

  Widget _buildVideoPlayer() {
    final controller = VideoPlayerController.file(_selectedMedia!);
    return FutureBuilder(
      future: controller.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildThirdPage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(value: _uploadProgress),
          const SizedBox(height: 16),
          Text('Uploading: ${(_uploadProgress * 100).toInt()}%'),
        ],
      ),
    );
  }
}

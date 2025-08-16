import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prism/core/localization/l10n/app_localizations.dart';
import 'package:prism/core/util/entities/media_entity.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/core/util/widgets/cached_network_video.dart';
import 'package:prism/core/util/widgets/custom_cached_network_image.dart';
import 'package:prism/core/util/widgets/custom_text_form_field.dart';
import 'package:prism/features/account/domain/enitities/post/post_entity.dart';
import 'package:prism/features/account/presentation/bloc/post/post_bloc/post_bloc.dart';
import 'package:prism/features/account/presentation/widgets/gallery_widget.dart';

class PostMediaData {
  final int? id;
  final File? localFile;
  final String? networkUrl;
  final MediaType type;

  PostMediaData({this.id, this.localFile, this.networkUrl, required this.type});
}

class CreatePostPage extends StatefulWidget {
  final PostEntity? existingPost;
  const CreatePostPage({super.key, this.existingPost});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _textFieldKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  String _selectedPrivacy = 'public';

  final List<PostMediaData> _mediaList = [];
  final List<int> removedMediaIds = []; // قائمة الوسائط المحذوفة من السيرفر
  bool _isLoadingMedia = false;
  final Map<String, double> _downloadProgress = {};

  @override
  void initState() {
    super.initState();
    _textController.text = widget.existingPost?.text ?? '';
    _selectedPrivacy = widget.existingPost?.privacy ?? 'public';
    if (widget.existingPost != null) {
      _loadExistingMediaFiles();
    }
  }

  Future<File> urlToFile(String url) async {
    final dio = Dio();
    final directory = await getApplicationDocumentsDirectory();
    final fileName = url.split("/").last;
    final savePath = "${directory.path}/$fileName";
    try {
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress[url] = received / total;
            });
          }
        },
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          followRedirects: true,
        ),
      );
      _downloadProgress.remove(url);
      return File(savePath);
    } catch (e) {
      _downloadProgress.remove(url);
      debugPrint("Download error: $e");
      rethrow;
    }
  }

  Future<void> _loadExistingMediaFiles() async {
    setState(() => _isLoadingMedia = true);
    // تحميل الوسائط من بيانات المنشور وربط كل وساطة بمعرفها (id)
    for (var media in widget.existingPost!.media) {
      try {
        File localFile = await urlToFile(media.url);
        _mediaList.add(
          PostMediaData(
            id: media.id,
            localFile: localFile,
            networkUrl: media.url,
            type: media.type,
          ),
        );
      } catch (e) {
        _mediaList.add(
          PostMediaData(id: media.id, networkUrl: media.url, type: media.type),
        );
      }
    }
    setState(() => _isLoadingMedia = false);
  }

  void _addMediaFromGallery(File file, MediaType type) {
    setState(() {
      _mediaList.add(PostMediaData(localFile: file, type: type));
    });
  }

  Future<void> _pickFromCamera({required bool isVideo}) async {
    final picker = ImagePicker();
    XFile? result;
    if (isVideo) {
      result = await picker.pickVideo(source: ImageSource.camera);
    } else {
      result = await picker.pickImage(source: ImageSource.camera);
    }
    if (result != null) {
      _addMediaFromGallery(
        File(result.path),
        isVideo ? MediaType.video : MediaType.image,
      );
    }
  }

  void _removeMediaAt(int index) {
    final media = _mediaList[index];
    if (media.id != null) {
      removedMediaIds.add(media.id!); // عند الحذف أضف id للقائمة
    }
    setState(() => _mediaList.removeAt(index));
  }

  void _submitPost() {
    if (!_formKey.currentState!.validate()) return;

    final newMediaFiles =
        _mediaList
            .where((m) => m.localFile != null)
            .map((m) => m.localFile!)
            .toList();

    if (widget.existingPost == null) {
      context.read<PostBloc>().add(
        AddNewPost(
          text: _textController.text.trim(),
          privacy: _selectedPrivacy,
          groupId: null,
          mediaPaths: newMediaFiles.map((f) => f.path).toList(),
        ),
      );
    } else {
      context.read<PostBloc>().add(
        UpdateExistingPost(
          userId: widget.existingPost!.user.id,
          postId: widget.existingPost!.id,
          text: _textController.text.trim(),
          privacy: _selectedPrivacy,
          mediaFiles: newMediaFiles,
          removedMediaIds:
              removedMediaIds, // أرسل قائمة معرفات الوسائط المحذوفة
        ),
      );
    }
  }

  Widget _buildPrivacyToggle() {
    final isPrivate = _selectedPrivacy == 'private';

    return Align(
      alignment: Alignment.topRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.privacy,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(width: 8),
          Switch(
            value: isPrivate,
            onChanged:
                (value) => setState(
                  () => _selectedPrivacy = value ? 'private' : 'public',
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingPost == null ? locale.createPost : locale.editPost,
        ),
      ),
      body:
          _isLoadingMedia
              ? const Center(child: CircularProgressIndicator())
              : BlocListener<PostBloc, PostState>(
                listener: (context, state) {
                  if (state is PostOperationSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          widget.existingPost == null
                              ? "Post Created Successfully"
                              : "Post Updated Successfully",
                        ),
                      ),
                    );
                    Navigator.pop(context);
                  } else if (state is PostError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text("Error")));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      _buildPrivacyToggle(),
                      const SizedBox(height: 16),
                      Form(
                        key: _formKey,
                        child: CustomTextFormField(
                          formkey: _textFieldKey,
                          textEditingController: _textController,
                          obsecure: false,
                          errorMessage: ".textValidationError",
                          hintText: "text...",
                          validator: (_) => null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_mediaList.isNotEmpty)
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _mediaList.length,
                            itemBuilder: (context, index) {
                              final media = _mediaList[index];
                              Widget mediaPreview;
                              if (media.networkUrl != null) {
                                final progress =
                                    _downloadProgress[media.networkUrl!];
                                mediaPreview = Stack(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 100,
                                      child:
                                          media.type == MediaType.image
                                              ? CustomCachedNetworkImage(
                                                imageUrl: media.networkUrl!,
                                                isRounded: false,
                                                radius: 0,
                                              )
                                              : CachedNetworkVideo(
                                                videoUrl: media.networkUrl!,
                                                showControls: true,
                                              ),
                                    ),
                                    if (progress != null)
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: LinearProgressIndicator(
                                          value: progress,
                                          minHeight: 3,
                                          color: Colors.blue,
                                          backgroundColor: Colors.grey.shade300,
                                        ),
                                      ),
                                  ],
                                );
                              } else {
                                mediaPreview =
                                    media.type == MediaType.image
                                        ? Image.file(
                                          media.localFile!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        )
                                        : const SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Icon(
                                            Icons.videocam,
                                            size: 48,
                                            color: Colors.black54,
                                          ),
                                        );
                              }

                              return Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey[300],
                                    child: mediaPreview,
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () => _removeMediaAt(index),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              child: Text("gallery"),
                              onPressed: () async {
                                final result =
                                    await showModalBottomSheet<PostMediaData>(
                                      context: context,
                                      builder:
                                          (context) => GalleryWidget(
                                            onMediaSelected: (file, type) {
                                              Navigator.pop(
                                                context,
                                                PostMediaData(
                                                  localFile: file,
                                                  type: type,
                                                ),
                                              );
                                            },
                                          ),
                                    );
                                if (result != null) {
                                  setState(() => _mediaList.add(result));
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppButton(
                              child: Text(locale.cameraImage),
                              onPressed: () => _pickFromCamera(isVideo: false),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppButton(
                              child: Text(locale.cameraVideo),
                              onPressed: () => _pickFromCamera(isVideo: true),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 36),
                      AppButton(
                        onPressed: _submitPost,
                        child: Text(
                          widget.existingPost == null ? "publish" : "update",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:prism/core/util/entities/media_entity.dart';
import 'package:prism/core/util/widgets/app_text_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GalleryWidget extends StatefulWidget {
  final Function(File, MediaType) onMediaSelected;

  const GalleryWidget({required this.onMediaSelected, super.key});

  @override
  GalleryWidgetState createState() => GalleryWidgetState();
}

class GalleryWidgetState extends State<GalleryWidget>
    with WidgetsBindingObserver {
  List<AssetEntity> _mediaList = [];
  bool _hasPermission = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestPermissionAndLoad();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_hasPermission) {
      _requestPermissionAndLoad();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _requestPermissionAndLoad() async {
    try {
      bool granted;
      if (Platform.isAndroid) {
        final storageGranted = await Permission.storage.request().isGranted;
        final photosGranted = await Permission.photos.request().isGranted;
        final videosGranted = await Permission.videos.request().isGranted;
        granted = storageGranted || photosGranted || videosGranted;
      } else {
        granted =
            await Permission.photos.request().isGranted &&
            await Permission.videos.request().isGranted;
      }

      setState(() {
        _hasPermission = granted;
        _isLoading = granted;
      });

      if (granted) {
        await _loadMedia();
      } else if (await Permission.photos.isPermanentlyDenied ||
          await Permission.storage.isPermanentlyDenied ||
          await Permission.videos.isPermanentlyDenied) {
        await openAppSettings();
      }
    } catch (e) {
      setState(() => _hasPermission = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorAccessingGallery(e.toString()),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMedia() async {
    try {
      final albums = await PhotoManager.getAssetPathList(type: RequestType.all);
      if (albums.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.noAlbumsFound),
            ),
          );
        }
        return;
      }
      final media = await albums[0].getAssetListRange(
        start: 0,
        end: 50,
      ); // Increased limit
      if (mounted) {
        setState(() => _mediaList = media);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorLoadingMedia(e.toString()),
            ),
          ),
        );
      }
    }
  }

  Widget _buildGallery() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: _mediaList.length,
      itemBuilder: (context, index) {
        final asset = _mediaList[index];
        return GestureDetector(
          onTap: () async {
            try {
              final file = await asset.file;
              if (file != null && mounted) {
                widget.onMediaSelected(
                  file,
                  asset.type == AssetType.video
                      ? MediaType.video
                      : MediaType.image,
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(
                        context,
                      )!.errorSelectingMedia(e.toString()),
                    ),
                  ),
                );
              }
            }
          },
          child: FutureBuilder<Uint8List?>(
            future: asset.thumbnailDataWithSize(
              const ThumbnailSize(100, 100),
              quality: 70,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.memory(snapshot.data!, fit: BoxFit.cover),
                    if (asset.type == AssetType.video)
                      const Center(
                        child: Icon(
                          Icons.play_circle_outline,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                  ],
                );
              }
              return Container(color: Colors.grey[300]);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _hasPermission
        ? _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _mediaList.isEmpty
            ? Center(child: Text(AppLocalizations.of(context)!.noMediaFound))
            : _buildGallery()
        : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.galleryAccessDenied),
              AppTextButton(
                onPressed: _requestPermissionAndLoad,
                text: AppLocalizations.of(context)!.requestPermission,
              ),
            ],
          ),
        );
  }
}

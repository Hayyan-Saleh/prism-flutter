import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';

import 'package:prism/core/util/entities/media_entity.dart';

class GalleryWidget extends StatefulWidget {
  final Function(File, MediaType) onMediaSelected;

  const GalleryWidget({required this.onMediaSelected, super.key});

  @override
  GalleryWidgetState createState() => GalleryWidgetState();
}

class GalleryWidgetState extends State<GalleryWidget> {
  List<AssetEntity> _mediaList = [];
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _requestPermissionAndLoad();
  }

  Future<void> _requestPermissionAndLoad() async {
    final PermissionState result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      setState(() => _hasPermission = true);
      _loadMedia();
    } else {
      setState(() => _hasPermission = false);
    }
  }

  Future<void> _loadMedia() async {
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.common, // Images and videos
    );
    if (albums.isNotEmpty) {
      final media = await albums[0].getAssetListRange(
        start: 0,
        end: 50,
      ); // Load first 50
      setState(() => _mediaList = media);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8, // 80% height
      child:
          _hasPermission
              ? _mediaList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                    itemCount: _mediaList.length,
                    itemBuilder: (context, index) {
                      final asset = _mediaList[index];
                      return GestureDetector(
                        onTap: () async {
                          final file = await asset.file;
                          if (file != null) {
                            widget.onMediaSelected(
                              file,
                              asset.type == AssetType.video
                                  ? MediaType.video
                                  : MediaType.image,
                            );
                          }
                        },
                        child: FutureBuilder<Widget>(
                          future: _buildThumbnail(asset),
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? snapshot.data!
                                : Container(color: Colors.grey[300]);
                          },
                        ),
                      );
                    },
                  )
              : const Center(child: Text('Gallery access denied')),
    );
  }

  Future<Widget> _buildThumbnail(AssetEntity asset) async {
    final thumbnail = await asset.thumbnailDataWithSize(
      const ThumbnailSize(100, 100),
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.memory(thumbnail!, fit: BoxFit.cover),
        if (asset.type == AssetType.video)
          const Center(
            child: Icon(Icons.play_circle_outline, color: Colors.white),
          ),
      ],
    );
  }
}

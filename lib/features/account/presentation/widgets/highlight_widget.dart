import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:prism/features/account/domain/enitities/account/highlight/highlight_entity.dart';

class HighlightWidget extends StatelessWidget {
  final HighlightEntity highlight;

  const HighlightWidget({super.key, required this.highlight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: _buildImageContainer(context)),
          const SizedBox(height: 8),
          _buildTextLabel(),
        ],
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 5,
      child: Container(
        decoration: _getContainerDecoration(context),
        child:
            highlight.cover == null ? _buildTextChild() : _buildCachedImage(),
      ),
    );
  }

  BoxDecoration _getContainerDecoration(BuildContext context) {
    return BoxDecoration(
      color:
          highlight.cover == null
              ? Theme.of(context).colorScheme.secondary
              : Colors.transparent,
      border: Border.all(color: Theme.of(context).colorScheme.onPrimary),
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget _buildCachedImage() {
    return CachedNetworkImage(
      imageUrl: highlight.cover!,
      imageBuilder:
          (context, imageProvider) => ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image(image: imageProvider, fit: BoxFit.cover),
          ),
      placeholder:
          (context, url) => SizedBox(
            height: 100,
            width: 100,
            child: Center(child: CircularProgressIndicator(strokeWidth: 4)),
          ),
      errorWidget:
          (context, url, error) => SizedBox(
            height: 100,
            width: 100,
            child: Center(child: Icon(Icons.error)),
          ),
    );
  }

  Widget _buildTextLabel() {
    return SizedBox(
      width: 70,
      child: Text(
        highlight.text ?? '',
        style: const TextStyle(fontWeight: FontWeight.bold),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTextChild() {
    return Center(
      child: Text(
        highlight.textAsCover ?? highlight.text ?? '',
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }
}

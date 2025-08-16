import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final bool isRounded;
  final String imageUrl;
  final double radius;

  const CustomCachedNetworkImage({
    super.key,
    required this.isRounded,
    required this.imageUrl,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return isRounded
        ? _buildRoundedCachedImage(context)
        : _buildRegularCachedImage(context);
  }

  Widget _buildRegularCachedImage(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(150),
      ),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        alignment: Alignment.center,
        fit: BoxFit.cover,
        progressIndicatorBuilder:
            (context, url, downloadProgress) => Center(
              child: SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
        errorWidget:
            (context, url, error) => Center(
              child: Text(
                isRounded ? "Error" : "Error downloading image",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildRoundedCachedImage(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      progressIndicatorBuilder:
          (context, url, downloadProgress) => Center(
            child: SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(
                value: downloadProgress.progress,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
      fit: BoxFit.cover,
      alignment: Alignment.center,
      imageBuilder:
          (context, imageProvider) => CircleAvatar(
            radius: radius,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.onPrimary.withAlpha(150),
            foregroundImage: imageProvider,
          ),
      errorWidget:
          (context, url, error) => Center(
            child: Text(
              "Error downloading image",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
    );
  }
}

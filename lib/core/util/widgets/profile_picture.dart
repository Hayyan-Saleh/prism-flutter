import 'package:flutter/material.dart';
import 'package:prism/core/util/widgets/custom_cached_network_image.dart';

class ProfilePicture extends StatelessWidget {
  final String? link;
  final double? radius;
  final bool hasStatus;
  const ProfilePicture({
    super.key,
    required this.link,
    this.radius,
    this.hasStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    final exists = link != null && link != '';
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    return Stack(
      alignment: Alignment.center,
      children: [
        if (hasStatus) ...[
          Container(
            width:
                (radius ?? 48) * 2 + (radius != null ? (0.375 * radius!) : 16),
            height:
                (radius ?? 48) * 2 + (radius != null ? (0.375 * radius!) : 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.lightGreenAccent, secondaryColor, Colors.green],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Container(
            width: (radius ?? 48) * 2 + 8,
            height: (radius ?? 48) * 2 + 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        ],
        CircleAvatar(
          radius: radius ?? 48,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.onPrimary.withAlpha(100),
          child:
              exists
                  ? CustomCachedNetworkImage(
                    imageUrl: link!,
                    isRounded: true,
                    radius: radius ?? 48,
                  )
                  : Icon(Icons.person, size: radius ?? 48),
        ),
      ],
    );
  }
}

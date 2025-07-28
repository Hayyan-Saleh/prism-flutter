import 'package:flutter/material.dart';
import 'package:prism/core/util/widgets/custom_cached_network_image.dart';

class ProfilePicture extends StatelessWidget {
  final String? link;
  final double? radius;
  final bool hasStatus;
  final bool owner;

  const ProfilePicture({
    super.key,
    required this.link,
    this.radius,
    this.hasStatus = false,
    this.owner = false,
  });

  @override
  Widget build(BuildContext context) {
    final exists = link != null && link != '';
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final effectiveRadius = radius ?? 48;

    return Stack(
      alignment: Alignment.center,
      children: [
        if (hasStatus || owner) ...[
          Container(
            width: effectiveRadius * 2 + (hasStatus || owner ? 12 : 0),
            height: effectiveRadius * 2 + (hasStatus || owner ? 12 : 0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors:
                    hasStatus
                        ? [
                          Colors.lightGreenAccent,
                          secondaryColor,
                          Colors.green,
                        ]
                        : [
                          Colors.lightBlueAccent,
                          Colors.blueGrey,
                          Colors.lightBlueAccent,
                        ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Container(
            width: effectiveRadius * 2 + 6,
            height: effectiveRadius * 2 + 6,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        ],
        ClipOval(
          child: Container(
            width: effectiveRadius * 2,
            height: effectiveRadius * 2,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary.withAlpha(100),
              shape: BoxShape.circle,
            ),
            child:
                exists
                    ? CustomCachedNetworkImage(
                      imageUrl: link!,
                      isRounded: true,
                      radius: effectiveRadius,
                    )
                    : Icon(Icons.person, size: effectiveRadius),
          ),
        ),
      ],
    );
  }
}

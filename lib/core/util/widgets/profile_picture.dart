import 'package:flutter/material.dart';
import 'package:prism/core/util/widgets/custom_cached_network_image.dart';
import 'package:prism/features/account/domain/enitities/account/main/account_role.dart';

class ProfilePicture extends StatelessWidget {
  final String? link;
  final double? radius;
  final bool hasStatus;
  final AccountRole? role;
  final bool live;

  const ProfilePicture({
    super.key,
    required this.link,
    this.radius,
    this.hasStatus = false,
    this.live = false,
    this.role,
  });

  @override
  Widget build(BuildContext context) {
    final exists = link != null && link != '';
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final effectiveRadius = radius ?? 48;
    final isMember = role != null && role == AccountRole.member;
    List<Color> ringColors =
        live
            ? [Colors.red, Colors.pink, Colors.red]
            : hasStatus
            ? [Colors.lightGreenAccent, secondaryColor, Colors.green]
            : _getColorByRole();

    return Stack(
      alignment: Alignment.center,
      children: [
        if (hasStatus || !isMember) ...[
          Container(
            width:
                effectiveRadius * 2 +
                (hasStatus || !isMember || live ? (radius ?? 100) / 4.5 : 0),
            height:
                effectiveRadius * 2 +
                (hasStatus || !isMember || live ? (radius ?? 100) / 4.5 : 0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: ringColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
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

  List<Color> _getColorByRole() {
    if (role == null) {
      return [Colors.transparent, Colors.transparent];
    }
    switch (role!) {
      case AccountRole.owner:
        return [
          Colors.lightBlueAccent,
          Colors.blueGrey,
          Colors.lightBlueAccent,
        ];
      case AccountRole.admin:
        return [Colors.amber, Colors.deepOrangeAccent, Colors.amber];
      case AccountRole.member:
        return [Colors.transparent, Colors.transparent];
    }
  }
}

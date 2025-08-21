import 'package:flutter/material.dart';

class TopNotification extends StatelessWidget {
  final String title;
  final String body;
  final VoidCallback? onTap;

  const TopNotification({
    super.key,
    required this.title,
    required this.body,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      color: Theme.of(context).colorScheme.secondary,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(body, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

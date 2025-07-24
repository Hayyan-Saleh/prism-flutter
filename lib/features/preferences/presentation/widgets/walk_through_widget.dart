import 'package:flutter/material.dart';
import 'package:prism/core/util/functions/functions.dart';

class WalkThroughWidget extends StatelessWidget {
  final String? imagePath;
  final String title;
  final Widget? customWidget;

  const WalkThroughWidget({
    super.key,
    this.imagePath,
    required this.title,
    this.customWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (imagePath != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Image.asset(imagePath!, height: 0.3 * getHeight(context)),
          ),
        Text(
          title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        if (customWidget != null) customWidget!,
      ],
    );
  }
}

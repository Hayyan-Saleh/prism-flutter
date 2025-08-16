import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color? bgColor;
  final Color? fgColor;
  const AppButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.bgColor,
    this.fgColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBgColor = Theme.of(context).colorScheme.onPrimary;
    final defaultFgColor = Theme.of(context).colorScheme.primary;
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: bgColor ?? defaultBgColor,
        foregroundColor: fgColor ?? defaultFgColor,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: () {
        onPressed();
        FocusScope.of(context).unfocus();
      },
      child: child,
    );
  }
}

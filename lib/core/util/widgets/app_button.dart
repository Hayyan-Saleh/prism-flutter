import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color color;
  const AppButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide.none,
      ),
      onPressed: onPressed,
      elevation: 0,
      child: child,
    );
  }
}

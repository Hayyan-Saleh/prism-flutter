import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class CodeWidget extends StatelessWidget {
  final int length;
  final TextEditingController controller;
  const CodeWidget({super.key, required this.length, required this.controller});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.onPrimary),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Pinput(
      controller: controller,
      length: length, // OTP length
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(color: Colors.blue),
        ),
      ),
    );
  }
}

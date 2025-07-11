import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/assets.dart';

class ErrorPage extends StatelessWidget {
  final String msg;
  const ErrorPage({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(msg: msg);
  }
}

class CustomErrorWidget extends StatelessWidget {
  final String msg;
  const CustomErrorWidget({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 32,
        children: [
          SvgPicture.asset(Assets.error, height: 0.2 * getHeight(context)),
          Text(
            msg,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

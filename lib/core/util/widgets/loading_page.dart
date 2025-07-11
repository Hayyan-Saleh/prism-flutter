import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/assets.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = getHeight(context);
    double width = getWidth(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: null,
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Prism",
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 0.4 * height,
              child: Image.asset(Assets.walkThrough1),
            ),
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            Text(
              AppLocalizations.of(context)!.wait,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}

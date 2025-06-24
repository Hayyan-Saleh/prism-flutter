import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/widgets/loading_page.dart';
import 'package:prism/features/preferences/presentation/bloc/preferences_bloc/preferences_bloc.dart';

class PreferencesMiddlePointPage extends StatelessWidget {
  final Function(ThemeMode) onThemeChanged;
  final Function(Locale) onLocaleChanged;

  const PreferencesMiddlePointPage({
    super.key,
    required this.onThemeChanged,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<PreferencesBloc, PreferencesState>(
      listener: (context, state) {
        if (state is LoadedPreferencesState) {
          Navigator.pushReplacementNamed(context, AppRoutes.authMiddlePoint);
        } else if (state is StartingWalkthroughState) {
          Navigator.pushReplacementNamed(context, AppRoutes.walkthrough);
        } else if (state is FailedStorePreferencesState) {
          showCustomAboutDialog(
            context,
            "Error",
            state.failure.message,
            null,
            true,
          );
        }
      },
      child: LoadingPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:test1/app.dart';
import 'package:test1/core/get_it/get_it.dart';
import 'package:test1/core/theme/app_theme.dart';
import 'package:test1/core/localization/localization_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/presentation/bloc/settings_bloc.dart';
import 'package:test1/presentation/bloc/settings_events.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init(); // Initialize dependencies

  runApp(
    BlocProvider(
      create: (context) => getIt<SettingsBloc>()..add(LoadSettingsEvent()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: state.locale?.toFlutterLocale(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: LocalizationService.supportedLocales,
          localeResolutionCallback:
              LocalizationService.localeResolutionCallback,
          theme: AppTheme.getTheme(state.theme?.themeType == ThemeType.dark),
          home: const App(),
        );
      },
    );
  }
}

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:realmo/core/di/injection_container.dart';
import 'package:realmo/features/preferences/presentation/bloc/preferences_bloc/preferences_bloc.dart';
import 'package:realmo/features/preferences/presentation/pages/walk_through_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/localization/l10n/app_localizations.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<PreferencesBloc>(
          create: (context) => sl<PreferencesBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('en');

  void _changeThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  void _changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      locale: _locale,
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
        scheme: FlexScheme.greenM3,
        primary: Colors.white,
        useMaterial3: true,
        fontFamily: 'sans-serif',
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.green,
        primary: Colors.black,
        useMaterial3: true,
        fontFamily: 'sans-serif',
      ),
      themeMode: _themeMode,
      home: WalkThroughPage(
        onThemeChanged: _changeThemeMode,
        onLocaleChanged: _changeLocale,
      ),
    );
  }
}

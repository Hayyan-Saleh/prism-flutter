import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/di/injection_container.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/account_name_bloc/account_name_bloc.dart';
import 'package:prism/features/account/presentation/pages/account/account_middle_point_page.dart';
import 'package:prism/features/account/presentation/pages/account/update_account_page.dart';
import 'package:prism/features/preferences/presentation/bloc/preferences_bloc/preferences_bloc.dart';
import 'package:prism/features/preferences/presentation/pages/walk_through_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/pages/settings_page.dart';
import 'package:prism/features/auth/presentation/BLoC/auth_bloc/auth_bloc.dart';
import 'package:prism/features/auth/presentation/pages/auth_middle_point.dart';
import 'package:prism/features/auth/presentation/pages/change_email_page.dart';
import 'package:prism/features/auth/presentation/pages/change_password_page.dart';
import 'package:prism/features/auth/presentation/pages/reset_password_page.dart';
import 'package:prism/features/auth/presentation/pages/signin_page.dart';
import 'package:prism/features/auth/presentation/pages/signup_page.dart';
import 'package:prism/features/auth/presentation/pages/verification_page.dart';
import 'package:prism/features/preferences/domain/entities/preferences_entity.dart';
import 'package:prism/features/preferences/presentation/pages/preferences_middle_point_page.dart';
import 'package:prism/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<PreferencesBloc>(
          create:
              (context) =>
                  sl<PreferencesBloc>()
                    ..add(DefinePreferencesCurrentStateEvent()),
        ),
        BlocProvider<AuthBloc>(
          create:
              (context) => sl<AuthBloc>()..add(DefineAuthCurrentStateEvent()),
        ),
        BlocProvider<PAccountBloc>(
          create:
              (context) =>
                  sl<PAccountBloc>()..add(DefinePAccountCurrentStateEvent()),
        ),
        BlocProvider<AccountNameBloc>(
          create: (context) => sl<AccountNameBloc>(),
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

  void _assignPreferences(PreferencesEntity preferences) {
    _locale = preferences.appLocal.locale;
    _themeMode = preferences.appTheme.themeMode;
  }

  Map<String, WidgetBuilder> _getRoutes() {
    return {
      AppRoutes.prefMiddlePoint:
          (context) => PreferencesMiddlePointPage(
            onLocaleChanged: _changeLocale,
            onThemeChanged: _changeThemeMode,
          ),
      AppRoutes.walkthrough:
          (context) => WalkThroughPage(
            onLocaleChanged: _changeLocale,
            onThemeChanged: _changeThemeMode,
          ),
      AppRoutes.authMiddlePoint: (context) => AuthMiddlePointPage(),
      AppRoutes.signin: (context) => SignInPage(),
      AppRoutes.signup: (context) => SignUpPage(),
      AppRoutes.verification: (context) => VerificationPage(),
      AppRoutes.reset: (context) => ResetPasswordPage(),
      AppRoutes.changeEmail: (context) => ChangeEmailPage(),
      AppRoutes.changePassword: (context) => ChangePasswordPage(),
      AppRoutes.accMiddlePoint: (context) => AccountMiddlePointPage(),
      AppRoutes.updateAccount: (context) => UpdateAccountPage(),
      AppRoutes.home: (context) => HomePage(),
      AppRoutes.myApp: (context) => MyApp(),
      AppRoutes.settings:
          (context) => SettingsPage(
            onLocaleChanged: _changeLocale,
            onThemeChanged: _changeThemeMode,
          ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferencesBloc, PreferencesState>(
      builder: (context, state) {
        if (state is LoadedPreferencesState) {
          _assignPreferences(state.preferences);
        } else if (state is DoneStorePreferencesState) {
          _assignPreferences(state.preferences);
        }
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
            scheme: FlexScheme.green,
            primary: Colors.grey[100],
            onPrimary: Colors.grey[900],
            useMaterial3: true,
            fontFamily: 'sans-serif',
          ).copyWith(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Theme.of(context).colorScheme.secondary,
              selectionColor: Theme.of(
                context,
              ).colorScheme.secondary.withAlpha(200),
              selectionHandleColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
          darkTheme: FlexThemeData.dark(
            scheme: FlexScheme.greenM3,
            primary: const Color.fromARGB(255, 24, 24, 24),
            onPrimary: Colors.grey[100],
            primaryLightRef: Colors.grey[100],
            useMaterial3: true,
            fontFamily: 'sans-serif',
          ).copyWith(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Theme.of(context).colorScheme.secondary,
              selectionColor: Theme.of(
                context,
              ).colorScheme.secondary.withAlpha(200),
              selectionHandleColor: Theme.of(context).colorScheme.secondary,
            ),
          ),

          themeMode: _themeMode,
          routes: _getRoutes(),
          initialRoute: AppRoutes.prefMiddlePoint,
        );
      },
    );
  }
}

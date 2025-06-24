import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/features/auth/presentation/BLoC/auth_bloc/auth_bloc.dart';
import 'package:prism/features/preferences/domain/entities/preferences_entity.dart';
import 'package:prism/features/preferences/domain/entities/preferences_enums.dart';
import 'package:prism/features/preferences/presentation/bloc/preferences_bloc/preferences_bloc.dart';

class SettingsPage extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final Function(Locale) onLocaleChanged;
  const SettingsPage({
    super.key,
    required this.onThemeChanged,
    required this.onLocaleChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late PreferencesEntity oldPreferences;
  String? themeMode;
  String? selectedLocal;

  @override
  void initState() {
    super.initState();
    context.read<PreferencesBloc>().add(DefinePreferencesCurrentStateEvent());
  }

  Widget _buildTitle1(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLogoutBtn(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.logout),
      trailing: const Icon(Icons.logout),
      onTap: () {
        context.read<AuthBloc>().add(LogoutAuthEvent());
      },
    );
  }

  Widget _buildChangeEmailBtn(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.changeEmail),
      trailing: const Icon(Icons.email_rounded),
      onTap: () {
        context.read<AuthBloc>().add(DefineAuthCurrentStateEvent());
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.changeEmail,
          ModalRoute.withName(AppRoutes.myApp),
        );
      },
    );
  }

  Widget _buildChangePasswordBtn(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.changePassword),
      trailing: const Icon(Icons.password_rounded),
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.changePassword);
      },
    );
  }

  Widget _buildChangeTheme(BuildContext context) {
    return BlocBuilder<PreferencesBloc, PreferencesState>(
      builder: (context, state) {
        if (state is LoadedPreferencesState) {
          oldPreferences = state.preferences;
          themeMode = state.preferences.appTheme.toString();
          selectedLocal = state.preferences.appLocal.toString();
        }

        return ListTile(
          title: Text(AppLocalizations.of(context)!.lightMode),
          trailing: Switch(
            trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              return Theme.of(context).colorScheme.secondary;
            }),
            value: oldPreferences.appTheme.themeMode == ThemeMode.light,
            onChanged: (value) {
              final newMode = value ? ThemeMode.light : ThemeMode.dark;
              switch (newMode) {
                case ThemeMode.light:
                  themeMode = Themes.light.toString();
                  break;
                case ThemeMode.dark:
                  themeMode = Themes.dark.toString();
                  break;
                default:
                  themeMode = oldPreferences.appTheme.toString();
              }

              widget.onThemeChanged(newMode);

              context.read<PreferencesBloc>().add(
                StorePreferencesEvent(
                  preferences: PreferencesEntity(
                    appTheme: Themes.fromString(themeMode!),
                    appLocal: Locales.fromString(
                      selectedLocal ?? oldPreferences.appLocal.toString(),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildChangeLanguage(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.appLanguage),
      trailing: DropdownButton<String>(
        value: selectedLocal,
        items:
            ['en', 'ar'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value == 'en'
                      ? AppLocalizations.of(context)!.english
                      : AppLocalizations.of(context)!.arabic,
                ),
              );
            }).toList(),
        onChanged: (String? newValue) {
          selectedLocal = newValue!;
          widget.onLocaleChanged(Locale(selectedLocal!));

          context.read<PreferencesBloc>().add(
            StorePreferencesEvent(
              preferences: PreferencesEntity(
                appTheme: Themes.fromString(
                  themeMode ?? oldPreferences.appTheme.toString(),
                ),
                appLocal: Locales.fromString(selectedLocal!),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAuthSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle1(context, AppLocalizations.of(context)!.authentication),
        _buildLogoutBtn(context),
        _buildChangeEmailBtn(context),
        _buildChangePasswordBtn(context),
      ],
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(right: 96, left: 96, top: 16.0),
      child: Divider(),
    );
  }

  List<Widget> _buildPreferencesSection() {
    return [
      _buildTitle1(context, AppLocalizations.of(context)!.preferences),
      _buildPreferencesBloc(),
    ];
  }

  Widget _buildPreferencesBloc() {
    return BlocConsumer<PreferencesBloc, PreferencesState>(
      listener: (context, state) {
        if (state is DoneStorePreferencesState) {
          context.read<PreferencesBloc>().add(
            DefinePreferencesCurrentStateEvent(),
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [_buildChangeTheme(context), _buildChangeLanguage(context)],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAuthSection(context),
            _buildDivider(),
            ..._buildPreferencesSection(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/domain/entities/theme_entity.dart';
import 'package:test1/domain/entities/locale_entity.dart';
import 'package:test1/presentation/bloc/settings_bloc.dart';
import 'package:test1/presentation/bloc/settings_events.dart';
import 'package:test1/presentation/bloc/settings_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.appTitle),
            actions: [
              // Theme toggle button
              IconButton(
                onPressed: () {
                  context.read<SettingsBloc>().add(ToggleThemeEvent());
                },
                icon: Icon(
                  state.theme?.themeType == ThemeType.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
              ),
              // Language switcher dropdown
              DropdownButton<AppLocale>(
                value: state.locale?.locale ?? AppLocale.en,
                items:
                    AppLocale.values.map((locale) {
                      return DropdownMenuItem(
                        value: locale,
                        child: Text(locale.displayName),
                      );
                    }).toList(),
                onChanged: (newLocale) {
                  if (newLocale != null) {
                    context.read<SettingsBloc>().add(
                      ChangeLocaleEvent(LocaleEntity(locale: newLocale)),
                    );
                  }
                },
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Theme display
                Text(
                  '${AppLocalizations.of(context)!.currentTheme}: '
                  '${state.theme?.themeType == ThemeType.dark ? 'Dark' : 'Light'}',
                ),
                const SizedBox(height: 20),
                // Locale display
                Text(
                  '${AppLocalizations.of(context)!.currentLanguage}: '
                  '${state.locale?.locale.displayName}',
                ),
                const SizedBox(height: 20),
                // Theme toggle button
                ElevatedButton(
                  onPressed: () {
                    context.read<SettingsBloc>().add(ToggleThemeEvent());
                  },
                  child: Text(AppLocalizations.of(context)!.toggleTheme),
                ),
                // Language toggle button
                ElevatedButton(
                  onPressed: () {
                    final newLocale =
                        state.locale?.locale == AppLocale.en
                            ? AppLocale.ar
                            : AppLocale.en;
                    context.read<SettingsBloc>().add(
                      ChangeLocaleEvent(LocaleEntity(locale: newLocale)),
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.toggleLanguage),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

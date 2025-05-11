import 'package:test1/domain/entities/theme_entity.dart';
import 'package:test1/domain/entities/locale_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsLocalDataSource {
  static const _themeKey = 'app_theme';
  static const _localeKey = 'app_locale';

  final SharedPreferences _prefs;

  SettingsLocalDataSource({required SharedPreferences prefs}) : _prefs = prefs;

  // Theme Methods
  Future<void> saveTheme(ThemeEntity theme) async {
    await _prefs.setString(_themeKey, theme.themeType.name);
  }

  Future<ThemeEntity> getTheme() async {
    final storedValue = _prefs.getString(_themeKey);
    return ThemeEntity(
      themeType:
          storedValue == ThemeType.dark.name ? ThemeType.dark : ThemeType.light,
    );
  }

  // Locale Methods
  Future<void> saveLocale(LocaleEntity locale) async {
    await _prefs.setString(_localeKey, locale.locale.name);
  }

  Future<LocaleEntity> getLocale() async {
    final storedValue = _prefs.getString(_localeKey);
    return LocaleEntity(
      locale: storedValue == AppLocale.ar.name ? AppLocale.ar : AppLocale.en,
    );
  }

  // Combined Operation (Optional)
  Future<void> saveSettings({ThemeEntity? theme, LocaleEntity? locale}) async {
    if (theme != null) await saveTheme(theme);
    if (locale != null) await saveLocale(locale);
  }
}

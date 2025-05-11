import 'package:test1/domain/entities/theme_entity.dart';
import 'package:test1/domain/entities/locale_entity.dart';

abstract class SettingsRepository {
  // Theme methods
  Future<ThemeEntity> getTheme();
  Future<void> saveTheme(ThemeEntity theme);

  // Localization methods
  Future<LocaleEntity> getLocale(); // Changed from AppLocale to LocaleEntity
  Future<void> saveLocale(LocaleEntity locale); // Changed parameter type

  // Combined persistence
  Future<void> saveSettings({
    ThemeEntity? theme,
    LocaleEntity? locale, // Changed from AppLocale to LocaleEntity
  }) async {
    if (theme != null) await saveTheme(theme);
    if (locale != null) await saveLocale(locale);
  }
}

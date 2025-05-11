import 'package:test1/data/datasource/theme_locale_datasource.dart';
import 'package:test1/domain/entities/theme_entity.dart';
import 'package:test1/domain/entities/locale_entity.dart';
import 'package:test1/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final ThemeLocaleDatasource _dataSource;

  SettingsRepositoryImpl({required ThemeLocaleDatasource dataSource})
    : _dataSource = dataSource;

  @override
  Future<ThemeEntity> getTheme() async {
    return await _dataSource.getTheme();
  }

  @override
  Future<void> saveTheme(ThemeEntity theme) async {
    await _dataSource.saveTheme(theme);
  }

  @override
  Future<LocaleEntity> getLocale() async {
    final locale = await _dataSource.getLocale();
    return LocaleEntity(locale: locale);
  }

  @override
  Future<void> saveLocale(LocaleEntity locale) async {
    await _dataSource.saveLocale(locale.locale);
  }

  @override
  Future<void> saveSettings({ThemeEntity? theme, LocaleEntity? locale}) async {
    if (theme != null) {
      await saveTheme(theme);
    }
    if (locale != null) {
      await saveLocale(locale);
    }
  }
}

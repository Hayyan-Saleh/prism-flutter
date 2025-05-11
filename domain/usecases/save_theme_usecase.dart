import 'package:test1/domain/entities/repository/settings_repository.dart';
import 'package:test1/domain/entities/theme_entity.dart';

class SaveThemeUseCase {
  final SettingsRepository repository;

  SaveThemeUseCase({required this.repository});

  Future<void> call(ThemeEntity theme) async {
    await repository.saveTheme(theme);
  }
}

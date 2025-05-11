import 'package:test1/domain/entities/repository/settings_repository.dart';
import 'package:test1/domain/entities/theme_entity.dart';

class GetThemeUseCase {
  final SettingsRepository repository;

  GetThemeUseCase({required this.repository});

  Future<ThemeEntity> call() async {
    return await repository.getTheme();
  }
}

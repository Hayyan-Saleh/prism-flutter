import 'package:test1/domain/entities/repository/settings_repository.dart';
import 'package:test1/domain/entities/locale_entity.dart';

class SaveLocaleUseCase {
  final SettingsRepository repository;

  SaveLocaleUseCase({required this.repository});

  Future<void> call(LocaleEntity locale) async {
    await repository.saveLocale(locale);
  }
}

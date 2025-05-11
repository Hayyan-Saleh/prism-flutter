import 'package:test1/domain/entities/repository/settings_repository.dart';
import 'package:test1/domain/entities/locale_entity.dart';

class GetLocaleUseCase {
  final SettingsRepository repository;

  GetLocaleUseCase({required this.repository});

  Future<LocaleEntity> call() async {
    return await repository.getLocale();
  }
}

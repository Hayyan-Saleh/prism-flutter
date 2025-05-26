import 'package:prism/features/preferences/domain/entities/preferences_entity.dart';
import 'package:prism/features/preferences/domain/entities/preferences_enums.dart';

class PreferencesModel extends PreferencesEntity {
  PreferencesModel({required super.appTheme, required super.appLocal});

  factory PreferencesModel.fromJson(Map<String, dynamic> json) {
    return PreferencesModel(
      appTheme: Themes.fromString(json['appTheme'] as String),
      appLocal: Locales.fromString(json['appLocal'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {'appTheme': appTheme.toString(), 'appLocal': appLocal.toString()};
  }

  factory PreferencesModel.fromEntity(PreferencesEntity entity) {
    return PreferencesModel(
      appTheme: entity.appTheme,
      appLocal: entity.appLocal,
    );
  }
}

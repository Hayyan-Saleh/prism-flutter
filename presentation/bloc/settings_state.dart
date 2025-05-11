import 'package:test1/domain/entities/theme_entity.dart';
import 'package:test1/domain/entities/locale_entity.dart';

enum SettingsStatus { initial, loading, success, error }

class SettingsState {
  final SettingsStatus status;
  final String? errorMessage;
  final ThemeEntity? theme;
  final LocaleEntity? locale;

  SettingsState._({
    required this.status,
    this.errorMessage,
    this.theme,
    this.locale,
  });

  factory SettingsState.initial() =>
      SettingsState._(status: SettingsStatus.initial);

  SettingsState copyWith({
    SettingsStatus? status,
    String? errorMessage,
    ThemeEntity? theme,
    LocaleEntity? locale,
  }) {
    return SettingsState._(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      theme: theme ?? this.theme,
      locale: locale ?? this.locale,
    );
  }
}

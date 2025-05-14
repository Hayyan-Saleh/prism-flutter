import 'package:equatable/equatable.dart';
import 'package:realmo/features/preferences/domain/entities/preferences_enums.dart';

class PreferencesEntity extends Equatable {
  final Themes appTheme;
  final Locales appLocal;

  const PreferencesEntity({required this.appTheme, required this.appLocal});

  @override
  List<Object?> get props => [appTheme, appLocal];
}

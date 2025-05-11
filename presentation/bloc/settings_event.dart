abstract class SettingsEvent {}

class LoadSettingsEvent extends SettingsEvent {}

class ToggleThemeEvent extends SettingsEvent {}

class ChangeLocaleEvent extends SettingsEvent {
  final LocaleEntity locale;

  ChangeLocaleEvent(this.locale);
}

enum AppLocale { en, ar }

extension AppLocaleExtension on AppLocale {
  String get displayName {
    switch (this) {
      case AppLocale.en:
        return 'English';
      case AppLocale.ar:
        return 'العربية';
    }
  }
}

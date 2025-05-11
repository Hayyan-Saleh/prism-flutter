import 'package:flutter/material.dart';

class LocalizationService {
  // Supported locales
  static const Locale enLocale = Locale('en');
  static const Locale arLocale = Locale('ar');

  // List of all supported locales
  static const List<Locale> supportedLocales = [enLocale, arLocale];

  // Default locale
  static const Locale defaultLocale = enLocale;

  /// Check if current locale is RTL
  static bool isRTL(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar';
  }

  /// Get device locale or default if not supported
  static Locale getDeviceLocale(BuildContext context) {
    final Locale? deviceLocale = Localizations.localeOf(context);
    return _isLocaleSupported(deviceLocale) ? deviceLocale! : defaultLocale;
  }

  /// Locale resolution callback for MaterialApp
  static Locale? localeResolutionCallback(
    Locale? deviceLocale,
    Iterable<Locale> supportedLocales,
  ) {
    // Check if device locale is supported
    if (_isLocaleSupported(deviceLocale)) {
      return deviceLocale;
    }

    // Try matching just the language code
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == deviceLocale?.languageCode) {
        return supportedLocale;
      }
    }

    // Return default if no match
    return defaultLocale;
  }

  /// Helper to check if locale is supported
  static bool _isLocaleSupported(Locale? locale) {
    if (locale == null) return false;
    return supportedLocales.any(
      (supported) =>
          supported.languageCode == locale.languageCode &&
          (supported.countryCode == null ||
              supported.countryCode == locale.countryCode),
    );
  }

  /// Get display name of a locale
  static String getLocaleDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      default:
        return 'English';
    }
  }

  /// Convert locale code string to Locale object
  static Locale localeFromString(String localeCode) {
    switch (localeCode) {
      case 'ar':
        return arLocale;
      case 'en':
      default:
        return enLocale;
    }
  }

  /// Convert Locale object to string code
  static String localeToString(Locale locale) {
    return locale.languageCode;
  }
}

import 'package:flutter/material.dart';

enum Themes {
  light,
  dark;

  @override
  String toString() {
    switch (this) {
      case Themes.light:
        return 'light';
      case Themes.dark:
        return 'dark';
    }
  }

  ThemeMode get themeMode {
    switch (this) {
      case Themes.light:
        return ThemeMode.light;
      case Themes.dark:
        return ThemeMode.dark;
    }
  }

  static Themes fromString(String value) {
    switch (value) {
      case 'light':
        return Themes.light;
      case 'dark':
        return Themes.dark;
      default:
        return Themes.light;
    }
  }
}

enum Locales {
  en,
  ar;

  @override
  String toString() {
    switch (this) {
      case Locales.en:
        return 'en';
      case Locales.ar:
        return 'ar';
    }
  }

  Locale get locale {
    switch (this) {
      case Locales.en:
        return const Locale('en');
      case Locales.ar:
        return const Locale('ar');
    }
  }

  static Locales fromString(String value) {
    switch (value) {
      case 'en':
        return Locales.en;
      case 'ar':
        return Locales.ar;
      default:
        return Locales.en;
    }
  }
}

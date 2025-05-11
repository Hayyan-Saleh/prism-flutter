import 'package:flutter/material.dart';
import 'package:test1/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData getTheme(bool isDark) {
    return ThemeData(
      useMaterial3: false,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: isDark ? AppColors.primaryDark : AppColors.primaryLight,
        onPrimary: isDark ? AppColors.onsurfaceDark : AppColors.onsurfaceLight,
        secondary: isDark ? AppColors.secondaryDark : AppColors.secondaryLight,
        onSecondary:
            isDark ? AppColors.onsurfaceDark : AppColors.onsurfaceLight,
        error: Colors.red,
        onError: Colors.white,
        surface: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        onSurface: isDark ? AppColors.onsurfaceDark : AppColors.onsurfaceLight,
      ),
    );
  }
}

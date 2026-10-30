import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.emerald,
      brightness: brightness,
    ).copyWith(
      primary: isDark ? AppColors.emeraldLight : AppColors.emerald,
      onPrimary: isDark ? const Color(0xFF04211C) : Colors.white,
      secondary: AppColors.gold,
      onSecondary: Colors.black,
      surface: isDark ? AppColors.nightBg : AppColors.ivory,
      onSurface: isDark ? AppColors.textOnDark : AppColors.textDark,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: 'HindSiliguri',
    );

    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: scheme.onSurface,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? AppColors.nightCard : Colors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.gold.withAlpha(60),
        height: 68,
      ),
    );
  }
}

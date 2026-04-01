import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/core/theme/text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final appTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.bg,
    ),
    scaffoldBackgroundColor: AppColors.bg,
    fontFamily: 'Rubik',
    textTheme: textTheme,

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.secondary.withValues(alpha: 0.5),
      selectionHandleColor: AppColors.primary,
    ),

    // Global Input Decoration (TextFields)
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: .circular(12),
        borderSide: const BorderSide(color: AppColors.borderEnabled),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: .circular(12),
        borderSide: const BorderSide(color: AppColors.borderFocused, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: .circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: .circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStatePropertyAll(
          AppColors.textPrimary.withValues(alpha: 0.1),
        ),
      ),
    ),

    // Global Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white.withValues(alpha: 0.1),
        minimumSize: const Size(.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: .circular(10)),
        elevation: 0,
      ),
    ),
  );
}

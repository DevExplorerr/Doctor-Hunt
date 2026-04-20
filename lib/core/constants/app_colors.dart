import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color primary = Color(0xFF0EBE7F);
  static const Color secondary = Color(0xFF677294);

  // Functional Colors
  static const Color review = Color(0xFFF6D060);
  static const Color icon = Color(0xFF858EA9);
  static const Color favorite = Color(0xFFFF0000);

  // Text Colors
  static const Color textPrimary = Color(0xFF222222);
  static const Color textSecondary = Color(0xFF677294);

  // Base Colors
  static const Color bg = Color(0xFFFFFFFF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color red = Color(0xFFFF0000);
  

  // Form/Border Colors
  static const Color borderEnabled = Color(0xFF858EA9);
  static const Color borderFocused = Color(0xFF677294);

  static const Color error = Color(0xFFFF0000);
  static const Color success = Color(0xff0EBE7E);

  static const Color transparent = Colors.transparent;

  // Helper for transparency
  static Color glass(double opacity) => white.withValues(alpha: opacity);
}

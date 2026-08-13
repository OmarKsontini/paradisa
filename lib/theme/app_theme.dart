import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF0F1117);
  static const Color surface = Color(0xFF1A1D26);
  static const Color surfaceLight = Color(0xFF232733);
  static const Color textPrimary = Color(0xFFF5F6FA);
  static const Color textSecondary = Color(0xFF9198A9);
  static const Color accent = Color(0xFF6C5CE7);
  static const Color success = Color(0xFF2ECC71);
  static const Color error = Color(0xFFE74C3C);

  static ThemeData theme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      fontFamily: 'Roboto',
      colorScheme: const ColorScheme.dark(
        primary: accent,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        foregroundColor: textPrimary,
        centerTitle: false,
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(color: textSecondary),
      ),
    );
  }
}
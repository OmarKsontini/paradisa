import 'package:flutter/material.dart';

class AppTheme {
  // Core palette
  static const Color background = Color(0xFF0D0E13);
  static const Color surface = Color(0xFF1A1D26);
  static const Color surfaceLight = Color(0xFF262A38);
  static const Color surfaceElevated = Color(0xFF20232F);

  static const Color textPrimary = Color(0xFFF5F6FA);
  static const Color textSecondary = Color(0xFF9298AB);
  static const Color textMuted = Color(0xFF676C7E);

  static const Color accent = Color(0xFF7C6AF0);
  static const Color accentSoft = Color(0xFF7C6AF0);
  static const Color success = Color(0xFF34C77B);
  static const Color error = Color(0xFFEF5A6F);
  static const Color warning = Color(0xFFF0B93D);

  // Spacing scale — use these instead of magic numbers
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;

  // Radius scale
  static const double radiusSmall = 10;
  static const double radiusMedium = 16;
  static const double radiusLarge = 22;

  static ThemeData theme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      fontFamily: 'Roboto',
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: success,
        surface: surface,
        error: error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: textPrimary,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 13,
          height: 1.35,
        ),
        labelSmall: TextStyle(
          color: textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMedium)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        labelStyle: const TextStyle(color: textSecondary),
      ),
    );
  }

  /// Reusable card container styling — one place to tune every card's look.
  static BoxDecoration cardDecoration({Color? accentGlow}) {
    return BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(radiusMedium),
      border: Border.all(color: surfaceLight, width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
        if (accentGlow != null)
          BoxShadow(
            color: accentGlow.withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: -4,
          ),
      ],
    );
  }
}
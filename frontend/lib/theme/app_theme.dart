// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Core palette
  static const Color obsidian = Color(0xFF080C14);
  static const Color deepNavy = Color(0xFF0D1321);
  static const Color surface = Color(0xFF111827);
  static const Color surfaceElevated = Color(0xFF1A2236);
  static const Color border = Color(0xFF1E2D45);

  // Accent
  static const Color teal = Color(0xFF00E5CC);
  static const Color tealDim = Color(0xFF00B09A);
  static const Color tealGlow = Color(0x3300E5CC);
  static const Color tealSoft = Color(0xFF0D3D37);

  // AI mode accent
  static const Color amber = Color(0xFFFFB830);
  static const Color amberGlow = Color(0x33FFB830);
  static const Color amberSoft = Color(0xFF2D2008);

  // Text
  static const Color textPrimary = Color(0xFFE8EDF5);
  static const Color textSecondary = Color(0xFF8A9BB5);
  static const Color textMuted = Color(0xFF4A5568);

  // Status
  static const Color success = Color(0xFF10D68A);
  static const Color error = Color(0xFFFF4D6A);
  static const Color warning = Color(0xFFFFB830);
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.obsidian,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.teal,
        secondary: AppColors.amber,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme().copyWith(
        displayLarge: GoogleFonts.syne(
          fontSize: 48,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          letterSpacing: -1.5,
        ),
        displayMedium: GoogleFonts.syne(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -1,
        ),
        displaySmall: GoogleFonts.syne(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.syne(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.spaceGrotesk(
          fontSize: 16,
          color: AppColors.textPrimary,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
        labelLarge: GoogleFonts.spaceGrotesk(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: AppColors.teal,
        ),
      ),
      useMaterial3: true,
    );
  }
}
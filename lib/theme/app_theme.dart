import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Futuristic Dark Navy & Electric Cyan Theme
  static const Color darkBg = Color(0xFF0A0F1D); // Deep Space Navy
  static const Color darkSurface = Color(0xFF0E1626);
  static const Color darkCard = Color(0xFF131D33); // Glassmorphic Navy
  static const Color darkCardElevated = Color(0xFF1B2844); // Elevated Card
  static const Color darkBorder = Color(0xFF223555); // Subtle Glass Border
  static const Color darkBorderGlow = Color(0xFF00E5FF); // Electric Cyan Glow

  // Accents & Gradients
  static const Color accentCyan = Color(0xFF00E5FF); // Neon Electric Cyan
  static const Color accentTeal = Color(0xFF2DD4BF); // Mint Teal
  static const Color accentBlue = Color(0xFF38BDF8); // Sky Blue
  static const Color accentPurple = Color(0xFF818CF8); // Indigo Purple
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color pureBlack = Color(0xFF000000);

  // Status & Health Indicators
  static const Color riskSafe = Color(0xFF10B981); // Emerald Green (Safe)
  static const Color riskModerate = Color(0xFFF59E0B); // Amber Yellow (Moderate)
  static const Color riskHigh = Color(0xFFEF4444); // Crimson Red (High Risk)
  static const Color riskCritical = Color(0xFFDC2626); // Critical Hazard

  // Standard Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Compatibility Aliases for UI Screens
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  static const Color lightBg = Color(0xFF0A0F1D); // Keep dark navy consistent
  static const Color lightSurface = Color(0xFF0E1626);
  static const Color lightCard = Color(0xFF131D33);
  static const Color lightCardElevated = Color(0xFF1B2844);
  static const Color lightBorder = Color(0xFF223555);
  static const Color lightTextPrimary = Color(0xFFFFFFFF);
  static const Color lightTextSecondary = Color(0xFF94A3B8);
  static const Color lightTextMuted = Color(0xFF64748B);

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF162544), Color(0xFF0F1A2E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyanGlowGradient = LinearGradient(
    colors: [Color(0xFF00E5FF), Color(0xFF2DD4BF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassCardGradient = LinearGradient(
    colors: [Color(0x331B2844), Color(0x1A0F1A2E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      primaryColor: AppColors.accentCyan,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentCyan,
        secondary: AppColors.accentTeal,
        surface: AppColors.darkCard,
        error: AppColors.riskHigh,
        onPrimary: AppColors.pureBlack,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        ThemeData.dark().textTheme.copyWith(
          displayLarge: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: -0.8,
          ),
          headlineLarge: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
          headlineMedium: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          titleLarge: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          titleMedium: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          bodyLarge: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
          bodyMedium: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
          labelLarge: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.pureBlack,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
    );
  }

  static ThemeData get lightTheme => darkTheme;
}

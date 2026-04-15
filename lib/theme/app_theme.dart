import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color goldPrimary = Color(0xFFB8860B);
  static const Color goldLight = Color(0xFFD4A017);
  static const Color goldBright = Color(0xFFFFD700);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF888888);
  static const Color inputBg = Color(0xFFFFFFFF);
  static const Color inputText = Color(0xFF000000);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color errorRed = Color(0xFFE53935);
  static const Color cardBg = Color(0xFF1C1C1C);
  static const Color divider = Color(0xFF2A2A2A);

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFB8860B), Color(0xFF8B6914), Color(0xFFD4A017)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF8B6914), Color(0xFFB8860B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTextStyles {
  static TextStyle headline1 = GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing: 0.5,
  );

  static TextStyle headline2 = GoogleFonts.playfairDisplay(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static TextStyle goldTitle = GoogleFonts.playfairDisplay(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.goldLight,
    letterSpacing: 2.0,
  );

  static TextStyle body = GoogleFonts.lato(
    fontSize: 14,
    color: AppColors.white,
  );

  static TextStyle bodyGrey = GoogleFonts.lato(
    fontSize: 13,
    color: AppColors.grey,
  );

  static TextStyle button = GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    letterSpacing: 0.5,
  );

  static TextStyle label = GoogleFonts.lato(
    fontSize: 12,
    color: AppColors.grey,
    fontWeight: FontWeight.w500,
  );

  static TextStyle link = GoogleFonts.lato(
    fontSize: 13,
    color: AppColors.goldLight,
    fontWeight: FontWeight.w600,
  );

  static TextStyle tagline = GoogleFonts.lato(
    fontSize: 15,
    color: AppColors.white,
    fontStyle: FontStyle.italic,
    height: 1.6,
  );
}

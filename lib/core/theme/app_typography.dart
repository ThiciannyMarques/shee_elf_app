import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextStyle display({
    required Color color,
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.w600,
  }) => GoogleFonts.fraunces(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    letterSpacing: 0,
  );

  static TextTheme textTheme(Color ink) {
    final base = GoogleFonts.manropeTextTheme();
    return base
        .copyWith(
          displayLarge: display(color: ink, fontSize: 44),
          displayMedium: display(color: ink, fontSize: 32),
          displaySmall: display(color: ink, fontSize: 24),
          headlineLarge: display(color: ink, fontSize: 24),
          headlineMedium: display(color: ink, fontSize: 20),
          headlineSmall: display(color: ink, fontSize: 17),
          titleLarge: display(color: ink, fontSize: 17),
          titleMedium: GoogleFonts.manrope(
            color: ink,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          titleSmall: GoogleFonts.manrope(
            color: ink,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
          bodyLarge: GoogleFonts.manrope(
            color: ink,
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: GoogleFonts.manrope(
            color: ink,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          bodySmall: GoogleFonts.manrope(
            color: ink,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          labelLarge: GoogleFonts.manrope(
            color: ink,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          labelMedium: GoogleFonts.manrope(
            color: ink,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          labelSmall: GoogleFonts.manrope(
            color: ink,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        )
        .apply(bodyColor: ink, displayColor: ink);
  }
}

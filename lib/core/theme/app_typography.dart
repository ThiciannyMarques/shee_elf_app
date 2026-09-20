import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Two-family type system: Fraunces for display/serif moments (titles,
/// book titles, the brandmark) and Manrope for UI/body text.
class AppTypography {
  AppTypography._();

  static TextStyle display({
    required Color color,
    double fontSize = 22,
    FontWeight fontWeight = FontWeight.w600,
  }) => GoogleFonts.fraunces(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    letterSpacing: -0.1,
  );

  static TextTheme textTheme(Color ink) {
    final base = GoogleFonts.manropeTextTheme();
    return base
        .copyWith(
          displayLarge: display(color: ink, fontSize: 37),
          displayMedium: display(color: ink, fontSize: 30),
          displaySmall: display(color: ink, fontSize: 26),
          headlineLarge: display(color: ink, fontSize: 26),
          headlineMedium: display(color: ink, fontSize: 21),
          headlineSmall: display(color: ink, fontSize: 18),
          titleLarge: display(color: ink, fontSize: 18),
          titleMedium: GoogleFonts.manrope(
            color: ink,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          titleSmall: GoogleFonts.manrope(
            color: ink,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          bodyLarge: GoogleFonts.manrope(color: ink, fontSize: 16),
          bodyMedium: GoogleFonts.manrope(color: ink, fontSize: 14),
          bodySmall: GoogleFonts.manrope(color: ink, fontSize: 13),
          labelLarge: GoogleFonts.manrope(
            color: ink,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          labelMedium: GoogleFonts.manrope(
            color: ink,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
          labelSmall: GoogleFonts.manrope(
            color: ink,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        )
        .apply(bodyColor: ink, displayColor: ink);
  }
}

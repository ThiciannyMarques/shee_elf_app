import 'package:flutter/material.dart';

/// Semantic color tokens for the "cozy fantasy library" visual language.
///
/// Materiality comes from solid, warm, natural pigments (moss, terracotta,
/// wine, plum, wood) rather than glow/gradient/glassmorphism — never give a
/// widget a bespoke color, pull it from here so light/dark stay in sync.
class AppColors extends ThemeExtension<AppColors> {
  final Color bg0;
  final Color bg1;
  final Color bg2;
  final Color bg3;
  final Color scrim;

  final Color ink;
  final Color inkSoft;
  final Color inkFaint;
  final Color textOnAccent;

  final Color line;
  final Color lineStrong;

  final Color moss;
  final Color mossDeep;
  final Color terracotta;
  final Color terracottaDeep;
  final Color wine;
  final Color plum;
  final Color deepBlue;
  final Color butter;
  final Color sand;
  final Color wood;
  final Color rose;

  const AppColors({
    required this.bg0,
    required this.bg1,
    required this.bg2,
    required this.bg3,
    required this.scrim,
    required this.ink,
    required this.inkSoft,
    required this.inkFaint,
    required this.textOnAccent,
    required this.line,
    required this.lineStrong,
    required this.moss,
    required this.mossDeep,
    required this.terracotta,
    required this.terracottaDeep,
    required this.wine,
    required this.plum,
    required this.deepBlue,
    required this.butter,
    required this.sand,
    required this.wood,
    required this.rose,
  });

  /// Amanhecer — light mode.
  static const light = AppColors(
    bg0: Color(0xFFF2E9D8),
    bg1: Color(0xFFFBF6EC),
    bg2: Color(0xFFE9DCC1),
    bg3: Color(0xFFDCCBA8),
    scrim: Color(0x6B3A2A1A),
    ink: Color(0xFF332417),
    inkSoft: Color(0xAD332417),
    inkFaint: Color(0x75332417),
    textOnAccent: Color(0xFFFBF6EC),
    line: Color(0x24332417),
    lineStrong: Color(0x42332417),
    moss: Color(0xFF5C7A54),
    mossDeep: Color(0xFF3F5A3C),
    terracotta: Color(0xFFBE6A3E),
    terracottaDeep: Color(0xFF8F4C29),
    wine: Color(0xFF7C3F42),
    plum: Color(0xFF63415C),
    deepBlue: Color(0xFF33455E),
    butter: Color(0xFFDDAE4C),
    sand: Color(0xFFC9A876),
    wood: Color(0xFF6E4A30),
    rose: Color(0xFFB97F72),
  );

  /// Noite — the same library at dusk.
  static const dark = AppColors(
    bg0: Color(0xFF1B2029),
    bg1: Color(0xFF232A36),
    bg2: Color(0xFF2B3341),
    bg3: Color(0xFF38424F),
    scrim: Color(0x94080A0E),
    ink: Color(0xFFEDE6D6),
    inkSoft: Color(0xB3EDE6D6),
    inkFaint: Color(0x75EDE6D6),
    textOnAccent: Color(0xFF1B140C),
    line: Color(0x1FEDE6D6),
    lineStrong: Color(0x38EDE6D6),
    moss: Color(0xFF7FA277),
    mossDeep: Color(0xFF5C7A54),
    terracotta: Color(0xFFD08653),
    terracottaDeep: Color(0xFFBE6A3E),
    wine: Color(0xFFB4696C),
    plum: Color(0xFF9576A0),
    deepBlue: Color(0xFF7C93B5),
    butter: Color(0xFFE8C06B),
    sand: Color(0xFF8A6C44),
    wood: Color(0xFF4A3320),
    rose: Color(0xFFC99A8E),
  );

  @override
  AppColors copyWith({
    Color? bg0,
    Color? bg1,
    Color? bg2,
    Color? bg3,
    Color? scrim,
    Color? ink,
    Color? inkSoft,
    Color? inkFaint,
    Color? textOnAccent,
    Color? line,
    Color? lineStrong,
    Color? moss,
    Color? mossDeep,
    Color? terracotta,
    Color? terracottaDeep,
    Color? wine,
    Color? plum,
    Color? deepBlue,
    Color? butter,
    Color? sand,
    Color? wood,
    Color? rose,
  }) {
    return AppColors(
      bg0: bg0 ?? this.bg0,
      bg1: bg1 ?? this.bg1,
      bg2: bg2 ?? this.bg2,
      bg3: bg3 ?? this.bg3,
      scrim: scrim ?? this.scrim,
      ink: ink ?? this.ink,
      inkSoft: inkSoft ?? this.inkSoft,
      inkFaint: inkFaint ?? this.inkFaint,
      textOnAccent: textOnAccent ?? this.textOnAccent,
      line: line ?? this.line,
      lineStrong: lineStrong ?? this.lineStrong,
      moss: moss ?? this.moss,
      mossDeep: mossDeep ?? this.mossDeep,
      terracotta: terracotta ?? this.terracotta,
      terracottaDeep: terracottaDeep ?? this.terracottaDeep,
      wine: wine ?? this.wine,
      plum: plum ?? this.plum,
      deepBlue: deepBlue ?? this.deepBlue,
      butter: butter ?? this.butter,
      sand: sand ?? this.sand,
      wood: wood ?? this.wood,
      rose: rose ?? this.rose,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      bg0: Color.lerp(bg0, other.bg0, t)!,
      bg1: Color.lerp(bg1, other.bg1, t)!,
      bg2: Color.lerp(bg2, other.bg2, t)!,
      bg3: Color.lerp(bg3, other.bg3, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkSoft: Color.lerp(inkSoft, other.inkSoft, t)!,
      inkFaint: Color.lerp(inkFaint, other.inkFaint, t)!,
      textOnAccent: Color.lerp(textOnAccent, other.textOnAccent, t)!,
      line: Color.lerp(line, other.line, t)!,
      lineStrong: Color.lerp(lineStrong, other.lineStrong, t)!,
      moss: Color.lerp(moss, other.moss, t)!,
      mossDeep: Color.lerp(mossDeep, other.mossDeep, t)!,
      terracotta: Color.lerp(terracotta, other.terracotta, t)!,
      terracottaDeep: Color.lerp(terracottaDeep, other.terracottaDeep, t)!,
      wine: Color.lerp(wine, other.wine, t)!,
      plum: Color.lerp(plum, other.plum, t)!,
      deepBlue: Color.lerp(deepBlue, other.deepBlue, t)!,
      butter: Color.lerp(butter, other.butter, t)!,
      sand: Color.lerp(sand, other.sand, t)!,
      wood: Color.lerp(wood, other.wood, t)!,
      rose: Color.lerp(rose, other.rose, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

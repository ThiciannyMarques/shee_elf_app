import 'package:flutter/material.dart';

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
  final Color woodMid;
  final Color rose;
  final Color skyNight;

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
    required this.woodMid,
    required this.rose,
    required this.skyNight,
  });

  static final light = AppColors(
    bg0: const Color(0xFFF4EDE0),
    bg1: const Color(0xFFEAE0CF),
    bg2: const Color(0xFFDDD2BC),
    bg3: const Color(0xFFCFC2A8),
    scrim: const Color(0xFFF4EDE0).withOpacity(0.88),
    ink: const Color(0xFF1C110A),
    inkSoft: const Color(0xFF1C110A).withOpacity(0.72),
    inkFaint: const Color(0xFF1C110A).withOpacity(0.44),
    textOnAccent: const Color(0xFFF4EDE0),
    line: const Color(0xFF1C110A).withOpacity(0.10),
    lineStrong: const Color(0xFF1C110A).withOpacity(0.22),
    moss: const Color(0xFF4E7A47),
    mossDeep: const Color(0xFF365630),
    terracotta: const Color(0xFFB86030),
    terracottaDeep: const Color(0xFF9A4A22),
    wine: const Color(0xFF963840),
    plum: const Color(0xFF6A4880),
    deepBlue: const Color(0xFF486898),
    butter: const Color(0xFF9A6810),
    sand: const Color(0xFFC9A876),
    wood: const Color(0xFF6B4A28),
    woodMid: const Color(0xFF8C6038),
    rose: const Color(0xFFA06850),
    skyNight: const Color(0xFF1A2040),
  );
  static final dark = AppColors(
    bg0: const Color(0xFF17151D),
    bg1: const Color(0xFF211C2B),
    bg2: const Color(0xFF2A2438),
    bg3: const Color(0xFF382F47),
    scrim: const Color(0xFF17151D).withOpacity(0.82),
    ink: const Color(0xFFEDE6D6),
    inkSoft: const Color(0xFFEDE6D6).withOpacity(0.72),
    inkFaint: const Color(0xFFEDE6D6).withOpacity(0.44),
    textOnAccent: const Color(0xFF17151D),
    line: const Color(0xFFEDE6D6).withOpacity(0.10),
    lineStrong: const Color(0xFFEDE6D6).withOpacity(0.22),
    moss: const Color(0xFF7FA277),
    mossDeep: const Color(0xFF5C7A54),
    terracotta: const Color(0xFFD08653),
    terracottaDeep: const Color(0xFFBE6A3E),
    wine: const Color(0xFFB4696C),
    plum: const Color(0xFF9576A0),
    deepBlue: const Color(0xFF7C93B5),
    butter: const Color(0xFFE8C06B),
    sand: const Color(0xFF8A6C44),
    wood: const Color(0xFF4A3320),
    woodMid: const Color(0xFF6B4C30),
    rose: const Color(0xFFC99A8E),
    skyNight: const Color(0xFF1A2040),
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
    Color? woodMid,
    Color? rose,
    Color? skyNight,
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
      woodMid: woodMid ?? this.woodMid,
      rose: rose ?? this.rose,
      skyNight: skyNight ?? this.skyNight,
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
      woodMid: Color.lerp(woodMid, other.woodMid, t)!,
      rose: Color.lerp(rose, other.rose, t)!,
      skyNight: Color.lerp(skyNight, other.skyNight, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

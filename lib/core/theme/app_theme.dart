import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light = _build(AppColors.light, Brightness.light);
  static ThemeData dark = _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColors colors, Brightness brightness) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.moss,
      onPrimary: colors.textOnAccent,
      secondary: colors.terracotta,
      onSecondary: colors.textOnAccent,
      tertiary: colors.plum,
      onTertiary: colors.textOnAccent,
      error: colors.wine,
      onError: colors.textOnAccent,
      surface: colors.bg1,
      onSurface: colors.ink,
      surfaceContainerHighest: colors.bg2,
      outline: colors.lineStrong,
      outlineVariant: colors.line,
    );

    final textTheme = AppTypography.textTheme(colors.ink);
    final borderRadius = BorderRadius.circular(AppRadius.md);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.bg0,
      canvasColor: colors.bg0,
      textTheme: textTheme,
      fontFamily: textTheme.bodyMedium?.fontFamily,
      extensions: [colors],
      dividerColor: colors.line,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.bg0,
        foregroundColor: colors.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineSmall,
        iconTheme: IconThemeData(color: colors.ink),
      ),
      cardTheme: CardThemeData(
        color: colors.bg1,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: colors.line, width: 1.0),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.bg1,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          side: BorderSide(color: colors.lineStrong, width: 1.0),
        ),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: colors.inkSoft),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.bg1,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
          side: BorderSide(color: colors.lineStrong, width: 1.0),
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: colors.bg1,
        surfaceTintColor: Colors.transparent,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.bg2,
        contentTextStyle: textTheme.bodyMedium,
        actionTextColor: colors.terracotta,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: colors.lineStrong, width: 1.0),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.moss,
          foregroundColor: colors.textOnAccent,
          disabledBackgroundColor: colors.bg3,
          disabledForegroundColor: colors.inkFaint,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.ink,
          side: BorderSide(color: colors.lineStrong, width: 1.0),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.terracotta,
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: colors.ink,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.terracotta,
        foregroundColor: colors.textOnAccent,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.bg1,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colors.line, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colors.line, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colors.terracotta, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colors.wine, width: 1.0),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(color: colors.inkSoft),
        hintStyle: textTheme.bodyMedium?.copyWith(color: colors.inkFaint),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colors.ink,
        textColor: colors.ink,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.bg1,
        side: BorderSide(color: colors.line, width: 1.0),
        labelStyle: textTheme.labelSmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.terracotta,
      ),
    );
  }
}

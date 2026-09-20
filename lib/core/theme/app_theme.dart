import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Builds the light and dark [ThemeData] for the app from the [AppColors]
/// design tokens. Widgets should read colors via `context.colors` (see
/// app_colors.dart) rather than hardcoding a [Color].
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
    final borderRadius = BorderRadius.circular(AppRadius.sm);

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
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: colors.line, width: 1.5),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.bg1,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: colors.lineStrong, width: 2),
        ),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colors.inkSoft,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.bg1,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
          side: BorderSide(color: colors.lineStrong, width: 2),
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: colors.bg1,
        surfaceTintColor: Colors.transparent,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.bg1,
        contentTextStyle: textTheme.bodyMedium,
        actionTextColor: colors.terracottaDeep,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: colors.lineStrong, width: 2),
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
            vertical: AppSpacing.lg,
          ),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.ink,
          side: BorderSide(color: colors.lineStrong, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.terracottaDeep,
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: colors.bg1,
          side: BorderSide(color: colors.line, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          foregroundColor: colors.ink,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.terracotta,
        foregroundColor: colors.textOnAccent,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: colors.terracottaDeep, width: 2),
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
          borderSide: BorderSide(color: colors.line, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colors.line, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colors.moss, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colors.wine, width: 1.5),
        ),
        labelStyle: textTheme.labelSmall?.copyWith(color: colors.inkFaint),
        hintStyle: textTheme.bodyMedium?.copyWith(color: colors.inkFaint),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colors.ink,
        textColor: colors.ink,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.bg1,
        side: BorderSide(color: colors.line, width: 1.5),
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
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.bg1,
        indicatorColor: colors.bg3,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}

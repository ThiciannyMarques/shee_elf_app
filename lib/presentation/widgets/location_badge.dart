import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_spacing.dart';

/// Picks an icon + accent color for a location from its name, so "Quarto",
/// "Sala", "Escritório", "Caixa" etc. each get a distinct, recognizable badge
/// without requiring a dedicated "type" field on [Location].
class LocationLook {
  final List<List<dynamic>> icon;
  final Color Function(AppColors colors) color;

  const LocationLook(this.icon, this.color);

  static LocationLook forName(String name) {
    final n = name.toLowerCase();
    if (n.contains('quarto') || n.contains('bed')) {
      return LocationLook(AppIcons.bed, (c) => c.wood);
    }
    if (n.contains('escritório') ||
        n.contains('escritorio') ||
        n.contains('estúdio') ||
        n.contains('estudio') ||
        n.contains('desk')) {
      return LocationLook(AppIcons.desk, (c) => c.mossDeep);
    }
    if (n.contains('caixa') || n.contains('box')) {
      return LocationLook(AppIcons.box, (c) => c.terracottaDeep);
    }
    if (n.contains('emprestad') || n.contains('empréstimo')) {
      return LocationLook(AppIcons.borrowed, (c) => c.deepBlue);
    }
    return LocationLook(AppIcons.location, (c) => c.plum);
  }
}

/// A small square badge — icon in a colored outline — matching the mockup's
/// "placa pendurada" (hung sign) treatment for locations.
class LocationBadge extends StatelessWidget {
  final String name;
  final double size;

  const LocationBadge({super.key, required this.name, this.size = 50});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final look = LocationLook.forName(name);
    final accent = look.color(colors);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.bg2,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: accent, width: 2),
      ),
      child: Center(
        child: HugeIcon(icon: look.icon, color: accent, size: size * 0.46),
      ),
    );
  }
}

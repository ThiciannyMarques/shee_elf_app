import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// The library's recurring empty/error/status illustration: a tinted icon
/// badge, a headline, a short explanation, and an optional primary action.
/// Used for empty collections, network errors, and scan/consult outcomes so
/// every "nothing here yet" moment in the app reads the same way.
class AppEmptyState extends StatelessWidget {
  final List<List<dynamic>> icon;
  final Color iconColor;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.secondaryLabel,
    this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: colors.bg2,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: iconColor, width: 2),
          ),
          child: Center(
            child: HugeIcon(icon: icon, color: iconColor, size: 28),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          title,
          style: textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          message,
          style: textTheme.bodyMedium?.copyWith(color: colors.inkSoft),
          textAlign: TextAlign.center,
        ),
        if (actionLabel != null) ...[
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
        if (secondaryLabel != null) ...[
          const SizedBox(height: AppSpacing.xs),
          TextButton(onPressed: onSecondary, child: Text(secondaryLabel!)),
        ],
      ],
    );
  }
}

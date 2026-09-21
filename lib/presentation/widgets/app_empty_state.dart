import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'primary_button.dart';
import 'secondary_button.dart';

class AppEmptyState extends StatelessWidget {
  final dynamic icon;
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

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: icon is IconData
                    ? Icon(icon as IconData, color: iconColor, size: 36)
                    : HugeIcon(
                        icon: icon as List<List<dynamic>>,
                        color: iconColor,
                        size: 36,
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              title,
              style: AppTypography.display(
                color: colors.ink,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.inkSoft,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                label: actionLabel!,
                onPressed: onAction,
                fullWidth: true,
              ),
            ],
            if (secondaryLabel != null) ...[
              const SizedBox(height: AppSpacing.md),
              SecondaryButton(
                label: secondaryLabel!,
                onPressed: onSecondary,
                fullWidth: true,
                variant: SecondaryButtonVariant.outline,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

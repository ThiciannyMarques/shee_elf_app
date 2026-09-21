import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

enum SecondaryButtonVariant { outline, terracotta }

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final SecondaryButtonVariant variant;
  final Widget? icon;

  const SecondaryButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.fullWidth = false,
    this.variant = SecondaryButtonVariant.outline,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isTC = variant == SecondaryButtonVariant.terracotta;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 48,
      child: isTC
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.terracottaDeep,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                elevation: 0,
              ),
              child: _buildContent(context, Colors.white),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.terracotta,
                side: BorderSide(color: colors.terracotta, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: _buildContent(context, colors.terracotta),
            ),
    );
  }

  Widget _buildContent(BuildContext context, Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[icon!, const SizedBox(width: 8)],
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

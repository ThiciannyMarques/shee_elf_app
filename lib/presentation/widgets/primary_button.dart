import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final Widget? icon;

  const PrimaryButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.fullWidth = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final disabled = onPressed == null;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.moss,
          disabledBackgroundColor: colors.mossDeep,
          foregroundColor: Colors.white,
          disabledForegroundColor: colors.inkFaint,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[icon!, const SizedBox(width: 8)],
            Text(
              label,
              style: textTheme.labelLarge?.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                color: disabled ? colors.inkFaint : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

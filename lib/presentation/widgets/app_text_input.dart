import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AppTextInput extends StatelessWidget {
  final String? label;
  final String? errorText;
  final String? hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const AppTextInput({
    Key? key,
    this.label,
    this.errorText,
    this.hintText,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final bool hasError = errorText != null && errorText!.isNotEmpty;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!.toUpperCase(),
            style: textTheme.labelSmall?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colors.inkFaint,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
        ],
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 15,
              color: colors.ink,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: colors.inkFaint),
              filled: true,
              fillColor: colors.bg2,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: hasError ? colors.wine : colors.lineStrong,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: hasError ? colors.wine : colors.terracotta,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colors.wine, width: 1),
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: textTheme.labelSmall?.copyWith(
              fontSize: 11,
              color: colors.wine,
            ),
          ),
        ],
      ],
    );
  }
}

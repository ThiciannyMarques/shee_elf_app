import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class LocationBadge extends StatelessWidget {
  final String name;
  final int bookCount;
  final VoidCallback? onTap;

  const LocationBadge({
    Key? key,
    required this.name,
    required this.bookCount,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        constraints: const BoxConstraints(minHeight: 52),
        decoration: BoxDecoration(
          color: colors.bg1,
          border: Border.all(color: colors.woodMid),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(Icons.vpn_key_outlined, size: 16, color: colors.terracotta),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontFamily: 'Fraunces',
                  fontSize: 15,
                  color: colors.ink,
                ),
              ),
            ),
            Text(
              '$bookCount livros',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 12,
                color: colors.inkFaint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

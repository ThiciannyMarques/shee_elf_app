import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// A book cover.
///
/// Books in this library don't carry a real cover image yet, so by default
/// this renders the mockup's "painted spine" placeholder: a solid, deterministic
/// color with the title lettered on top. Pass [imageUrl] once real cover art is
/// available and it renders that instead (`AspectRatio` + `BoxFit.cover`, with
/// the painted spine as the loading/error fallback) — no call site changes.
class BookCoverTile extends StatelessWidget {
  final String title;
  final String seed;
  final String? imageUrl;
  final double width;
  final double height;
  final double tiltDegrees;

  const BookCoverTile({
    super.key,
    required this.title,
    required this.seed,
    this.imageUrl,
    this.width = 74,
    this.height = 112,
    this.tiltDegrees = 0,
  });

  static const _palette = [
    Color(0xFF4D6B4A),
    Color(0xFF63415C),
    Color(0xFFA9673B),
    Color(0xFF33455E),
    Color(0xFF7C3F42),
    Color(0xFF5F7859),
  ];

  Color _spineColor() {
    final hash = seed.codeUnits.fold<int>(0, (acc, c) => acc + c);
    return _palette[hash % _palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final spine = imageUrl == null ? _spineColor() : colors.bg2;

    Widget content = Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(AppSpacing.sm),
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        color: spine,
        borderRadius: BorderRadius.circular(AppRadius.cover),
        border: Border.all(color: Colors.black.withValues(alpha: 0.12)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl != null)
            Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: _spineColor(),
              ),
              loadingBuilder: (context, child, progress) =>
                  progress == null ? child : Container(color: _spineColor()),
            ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(width: 4, color: Colors.black.withValues(alpha: 0.16)),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.xs),
              child: Text(
                title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.display(
                  color: Colors.white.withValues(alpha: 0.96),
                  fontSize: width < 80 ? 10 : 12,
                  fontWeight: FontWeight.w600,
                ).copyWith(
                  height: 1.25,
                  shadows: const [
                    Shadow(color: Colors.black54, blurRadius: 2, offset: Offset(0, 1)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (tiltDegrees != 0) {
      content = Transform.rotate(
        angle: tiltDegrees * 3.1415926535 / 180,
        child: content,
      );
    }
    return content;
  }
}

/// Deterministic per-book tilt, matching the mockup's hand-placed shelf look.
double tiltForSeed(String seed) {
  const tilts = [-2.0, 1.5, -1.0, 2.0, -1.5];
  final hash = seed.codeUnits.fold<int>(0, (acc, c) => acc + c);
  return tilts[hash % tilts.length];
}

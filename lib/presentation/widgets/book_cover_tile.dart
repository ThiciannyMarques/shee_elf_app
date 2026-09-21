import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class BookCoverTile extends StatelessWidget {
  final String title;
  final String seed;
  final String? imageUrl;
  final double width;
  final double height;
  final double tiltDegrees;
  final String? author;
  final VoidCallback? onTap;

  const BookCoverTile({
    super.key,
    required this.title,
    required this.seed,
    this.imageUrl,
    this.width = 74,
    this.height = 112,
    this.tiltDegrees = 0,
    this.author,
    this.onTap,
  });

  static const _palette = [
    Color(0xFFB4696C),
    Color(0xFF9576A0),
    Color(0xFF7C93B5),
    Color(0xFF7FA277),
    Color(0xFFD08653),
    Color(0xFFC99A8E),
    Color(0xFF6B4C30),
    Color(0xFF8A6FA0),
    Color(0xFF6B8C7A),
    Color(0xFFA07855),
  ];

  Color _spineColor() {
    final hash = seed.codeUnits.fold<int>(0, (acc, c) => acc + c);
    return _palette[hash % _palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final spine = imageUrl == null ? _spineColor() : colors.bg2;

    final borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(4),
      bottomLeft: Radius.circular(4),
      topRight: Radius.circular(8),
      bottomRight: Radius.circular(8),
    );

    Widget content = GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: spine,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl != null)
              Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: _spineColor()),
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : Container(color: _spineColor()),
              ),

            if (imageUrl == null)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.06),
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),

            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 6, color: Colors.black.withOpacity(0.35)),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 1, color: Colors.white.withOpacity(0.08)),
            ),

            if (imageUrl == null)
              Positioned(
                top: 8,
                left: 12,
                right: 8,
                bottom: 8,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

            if (imageUrl == null)
              Padding(
                padding: EdgeInsets.only(
                  left: width < 100 ? 16 : 20,
                  right: width < 100 ? 12 : 20,
                  bottom: width < 100 ? 12 : 24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: width < 100 ? 3 : 4,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.display(
                        color: Colors.white.withOpacity(0.92),
                        fontSize: width < 100 ? 14 : 22,
                        fontWeight: FontWeight.w600,
                      ).copyWith(height: 1.2),
                    ),
                    if (author != null && width >= 100) ...[
                      const SizedBox(height: 8),
                      Text(
                        author!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.65),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
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

double tiltForSeed(String seed) {
  const tilts = [-2.0, 1.5, -1.0, 2.0, -1.5];
  final hash = seed.codeUnits.fold<int>(0, (acc, c) => acc + c);
  return tilts[hash % tilts.length];
}

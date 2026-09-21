import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_colors.dart';

/// A themed image slot — not an illustration generator.
///
/// Looks for a real asset at `assets/<sceneKey>_<light|dark>.<ext>`, trying
/// `.svg`, `.gif`, `.png`, then `.jpg`/`.jpeg` — whichever file actually gets
/// dropped in works with no code change. Picks light/dark automatically
/// from the current [Brightness] unless [forceDark] is set.
///
/// When no matching file exists yet, this renders a flat, theme-colored
/// panel instead of a placeholder illustration — honest and unfinished-
/// looking is better than faking art with vector shapes.
///
/// Note: SVGs render as a static frame — Flutter's SVG renderer does not
/// execute SMIL/CSS animations embedded in the file. Any motion for an SVG
/// scene has to come from a Flutter-native overlay layered on top (see
/// `SplashMotionOverlay` for an example), not from the SVG's own markup.
class SceneImage extends StatelessWidget {
  final String sceneKey;
  final BoxFit fit;
  final Widget? child;
  final AlignmentGeometry childAlignment;
  final bool? forceDark;

  const SceneImage({
    super.key,
    required this.sceneKey,
    this.fit = BoxFit.cover,
    this.child,
    this.childAlignment = Alignment.center,
    this.forceDark,
  });

  static const _extensions = ['svg', 'gif', 'png', 'jpg', 'jpeg'];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = forceDark ?? Theme.of(context).brightness == Brightness.dark;
    final variant = isDark ? 'dark' : 'light';
    final fallbackColor = isDark ? colors.deepBlue : colors.bg2;

    final candidates = [
      for (final ext in _extensions) 'assets/${sceneKey}_$variant.$ext',
    ];

    return Stack(
      fit: StackFit.expand,
      children: [
        _AssetCascade(
          candidates: candidates,
          fit: fit,
          fallbackColor: fallbackColor,
        ),
        if (child != null) Align(alignment: childAlignment, child: child),
      ],
    );
  }
}

/// Tries each asset path in order, falling back to a flat color panel if
/// none of them exist. Each image widget manages its own load error
/// independently, so chaining via `errorBuilder` is safe.
class _AssetCascade extends StatelessWidget {
  final List<String> candidates;
  final BoxFit fit;
  final Color fallbackColor;

  const _AssetCascade({
    required this.candidates,
    required this.fit,
    required this.fallbackColor,
  });

  @override
  Widget build(BuildContext context) {
    if (candidates.isEmpty) {
      return ColoredBox(color: fallbackColor);
    }
    final path = candidates.first;
    final rest = candidates.sublist(1);
    final fallback = _AssetCascade(
      candidates: rest,
      fit: fit,
      fallbackColor: fallbackColor,
    );

    if (path.endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    }
    return Image.asset(
      path,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => fallback,
    );
  }
}

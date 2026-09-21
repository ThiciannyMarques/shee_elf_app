import 'package:flutter/material.dart';

/// Keeps a scene (art + overlays) readable on any phone or tablet by always
/// filling the full height and letting the width overflow/crop instead of
/// letterboxing.
///
/// Content is laid out in the art's own reference pixels (e.g. the SVG's
/// `viewBox`), then scaled as one unit so the scene always spans the full
/// screen height — anything anchored near the top (a logo) or bottom (a
/// loading indicator) is always on screen — while the sides crop first on
/// unusually wide/narrow screens instead of shrinking everything down to
/// fit.
class ResponsiveScene extends StatelessWidget {
  final double referenceWidth;
  final double referenceHeight;
  final Color backgroundColor;
  final Widget child;

  const ResponsiveScene({
    super.key,
    required this.referenceWidth,
    required this.referenceHeight,
    required this.backgroundColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = constraints.maxHeight / referenceHeight;
            // OverflowBox gives its CHILD the original, unscaled reference
            // size (so the SizedBox below is never compressed), while
            // reporting `constraints.biggest` (the real screen size) up to
            // its own parent. Transform.scale then blows the whole thing up
            // to fill the screen's height, and whatever no longer fits
            // horizontally is cropped by the ClipRect above.
            return OverflowBox(
              minWidth: referenceWidth,
              maxWidth: referenceWidth,
              minHeight: referenceHeight,
              maxHeight: referenceHeight,
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.center,
                child: SizedBox(
                  width: referenceWidth,
                  height: referenceHeight,
                  child: child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The handful of things worth animating on top of the painted splash
/// scene — the art itself is a static SVG (Flutter can't run an SVG's own
/// SMIL animations), so any motion has to be layered natively: stars
/// twinkling in the sky, and steam rising off the coffee cup on the
/// windowsill. Positions are normalized fractions of the artwork's frame,
/// eyeballed against `assets/splash_dark.svg` — nudge them if the art
/// changes.
class SplashMotionOverlay extends StatefulWidget {
  const SplashMotionOverlay({super.key});

  @override
  State<SplashMotionOverlay> createState() => _SplashMotionOverlayState();
}

class _SplashMotionOverlayState extends State<SplashMotionOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _SplashMotionPainter(t: _controller.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _Star {
  final double dx;
  final double dy;
  final double phase;
  final double armLength;

  const _Star(this.dx, this.dy, this.phase, this.armLength);
}

class _SplashMotionPainter extends CustomPainter {
  final double t;

  const _SplashMotionPainter({required this.t});

  // Kept strictly inside the "window" — clear of the bookshelf/stone frame
  // on both sides (x < 0.22 or x > 0.80 lands on the walls, not the sky),
  // clear of the "She Elf" title, and clear of the moon's disc (centered
  // around x:0.50, y:0.26 — a star can't float in front of a solid moon).
  static const _stars = [
    _Star(0.24, 0.03, 0.1, 2.2),
    _Star(0.30, 0.09, 0.4, 1.8),
    _Star(0.36, 0.02, 0.7, 2.6),
    _Star(0.42, 0.15, 0.25, 2.0),
    _Star(0.48, 0.04, 0.55, 2.4),
    _Star(0.30, 0.28, 0.85, 1.8),
    _Star(0.60, 0.03, 0.15, 2.8),
    _Star(0.66, 0.12, 0.6, 2.0),
    _Star(0.72, 0.02, 0.35, 2.2),
    _Star(0.78, 0.08, 0.9, 2.6),
    _Star(0.28, 0.22, 0.5, 1.8),
    _Star(0.26, 0.25, 0.05, 2.0),
    _Star(0.76, 0.22, 0.7, 1.8),
    _Star(0.75, 0.18, 0.2, 2.4),
    _Star(0.34, 0.13, 0.65, 2.0),
    _Star(0.58, 0.10, 0.4, 2.2),
  ];

  // Coffee cup's rim — where the art's own static steam wisp begins. These
  // puffs extend that same wisp upward instead of drawing a disconnected
  // one. (Cup sits around x:0.67, y:0.77 of the frame; the rim is a touch
  // above its center.)
  static const _steamBaseX = 0.665;
  static const _steamBaseY = 0.755;

  void _drawStar(Canvas canvas, Offset center, double armLength, Paint paint) {
    canvas.drawLine(
      Offset(center.dx - armLength, center.dy),
      Offset(center.dx + armLength, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - armLength),
      Offset(center.dx, center.dy + armLength),
      paint,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final starPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round;

    for (final star in _stars) {
      final twinkle =
          0.3 +
          0.7 * (0.5 + 0.5 * math.sin(2 * math.pi * (t * 4 + star.phase)));
      starPaint.color = Colors.white.withValues(alpha: twinkle.clamp(0.0, 1.0));
      _drawStar(
        canvas,
        Offset(size.width * star.dx, size.height * star.dy),
        star.armLength,
        starPaint,
      );
    }

    for (var i = 0; i < 3; i++) {
      final localT = (t + i / 3) % 1.0;
      final rise = localT * size.height * 0.055;
      final drift = math.sin(localT * 2 * math.pi + i) * 2.5;
      final opacity = (1 - localT) * 0.4;
      final radius = 2 + localT * 5;
      final puffPaint = Paint()
        ..color = Colors.white.withValues(alpha: opacity.clamp(0.0, 1.0));
      canvas.drawCircle(
        Offset(
          size.width * _steamBaseX + drift,
          size.height * _steamBaseY - rise,
        ),
        radius,
        puffPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SplashMotionPainter oldDelegate) =>
      oldDelegate.t != t;
}

import 'package:flutter/material.dart';

/// Three small dots pulsing in sequence — no card, no border, nothing that
/// reads as a UI box sitting on top of painted art. Meant to float directly
/// over a scene (e.g. near the lantern on the splash) rather than live on a
/// flat surface.
class EmberDotsLoader extends StatefulWidget {
  final Color color;
  final double dotSize;

  const EmberDotsLoader({
    super.key,
    this.color = const Color(0xFFDDAE4C),
    this.dotSize = 6,
  });

  @override
  State<EmberDotsLoader> createState() => _EmberDotsLoaderState();
}

class _EmberDotsLoaderState extends State<EmberDotsLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 3; i++) ...[
              if (i > 0) SizedBox(width: widget.dotSize * 0.7),
              _buildDot(i),
            ],
          ],
        );
      },
    );
  }

  Widget _buildDot(int index) {
    final phase = (index * 0.22);
    final localT = (_controller.value + phase) % 1.0;
    final pulse = (localT < 0.5) ? (localT * 2) : (2 - localT * 2);
    final opacity = 0.35 + pulse * 0.65;
    final scale = 0.7 + pulse * 0.3;

    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: widget.dotSize,
          height: widget.dotSize,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

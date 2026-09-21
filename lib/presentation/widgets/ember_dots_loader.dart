import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class EmberDotsLoader extends StatefulWidget {
  final Color? color;
  final double dotSize;

  const EmberDotsLoader({super.key, this.color, this.dotSize = 6});

  @override
  State<EmberDotsLoader> createState() => _EmberDotsLoaderState();
}

class _EmberDotsLoaderState extends State<EmberDotsLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultColor =
        Theme.of(context).extension<AppColors>()?.terracotta ??
        const Color(0xFFD08653);
    final dotColor = widget.color ?? defaultColor;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 3; i++) ...[
              if (i > 0) SizedBox(width: widget.dotSize * 1.5),
              _buildDot(i, dotColor),
            ],
          ],
        );
      },
    );
  }

  Widget _buildDot(int index, Color color) {
    final phase = index * 0.2;
    final localT = (_controller.value + phase) % 1.0;

    final pulse = localT < 0.5 ? localT * 2 : 2 - (localT * 2);
    final opacity = 0.3 + (pulse * 0.7);
    final scale = 0.8 + (pulse * 0.4);

    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: widget.dotSize,
          height: widget.dotSize,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              if (pulse > 0.5)
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

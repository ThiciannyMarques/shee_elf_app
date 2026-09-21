// Pré-visualização temporária da splash screen — não faz parte do app.
import 'package:flutter/material.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'presentation/widgets/ember_dots_loader.dart';
import 'presentation/widgets/responsive_scene.dart';
import 'presentation/widgets/scene_image.dart';
import 'presentation/widgets/splash_motion_overlay.dart';

void main() => runApp(const _PreviewApp());

class _PreviewApp extends StatelessWidget {
  const _PreviewApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          final colors = context.colors;
          return Scaffold(
            body: ResponsiveScene(
              referenceWidth: 768,
              referenceHeight: 1376,
              backgroundColor: colors.deepBlue,
              child: const Stack(
                fit: StackFit.expand,
                children: [
                  SceneImage(sceneKey: 'splash'),
                  SplashMotionOverlay(),
                  Align(
                    alignment: Alignment(0, 0.97),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: EmberDotsLoader(dotSize: 7),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

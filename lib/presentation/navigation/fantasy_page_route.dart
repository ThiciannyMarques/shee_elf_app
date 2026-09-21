import 'package:flutter/material.dart';

/// A soft cross-fade with a gentle upward drift — used for the handful of
/// hops that should feel like turning to the next page of the same story
/// (splash → login, login ↔ register ↔ initial collection) rather than a
/// generic platform slide. Deliberately not used everywhere: most
/// navigation in the app should stay fast and unremarkable.
class FantasyPageRoute<T> extends PageRouteBuilder<T> {
  FantasyPageRoute({required WidgetBuilder builder})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
        transitionDuration: const Duration(milliseconds: 280),
        reverseTransitionDuration: const Duration(milliseconds: 220),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.03),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      );
}

import 'package:flutter/material.dart';

class FadeSlideAnimationContainer extends StatelessWidget {
  const FadeSlideAnimationContainer({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key);
  final Animation<double> animation;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0,
        end: 1,
      ).animate(animation),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, -0.1),
          end: Offset.zero,
        ).animate(animation),
        // Paste you Widget
        child: child,
      ),
    );
  }
}

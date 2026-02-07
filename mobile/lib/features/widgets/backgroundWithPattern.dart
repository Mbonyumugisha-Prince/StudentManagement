import 'package:flutter/material.dart';
import 'SquaresPainter.dart';

class BackgroundWithPattern extends StatelessWidget {
  final Widget child;

  const BackgroundWithPattern({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: 0.08,
            child: CustomPaint(painter: SquaresPainter()),
          ),
        ),
        child,
      ],
    );
  }
}
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:test_gui/cubit/triangle_rotation_cubit.dart';

class DrawFigures extends StatelessWidget {
  const DrawFigures({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const Text('Draw Figures', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          BlocSelector<TriangleRotationCubit, TriangleRotationState, double>(
            selector: (s) => s.angle,
            builder:
                (context, v) => RepaintBoundary(
                  child: Column(
                    children: [
                      AspectRatio(aspectRatio: 1, child: CustomPaint(painter: DrawFiguresPainter(v))),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32, top: 16),
                        child: Column(
                          children: [
                            Text('Current Radians: ${(v).toStringAsFixed(2)}'),
                            Text('Current Degrees: ${(v * 180 / math.pi).toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

class DrawFiguresPainter extends CustomPainter {
  static final circlePaint =
      Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;
  static final trianglePaint =
      Paint()
        ..color = Colors.green
        ..style = PaintingStyle.fill;

  final double angle;

  DrawFiguresPainter(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final circleRadius = math.min(size.width, size.height) * 0.5;

    canvas.drawCircle(center, circleRadius, circlePaint);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    final trianglePath = Path();

    for (var i = 0; i < 3; i++) {
      final vertex = -math.pi * 0.5 + (i * 2 * math.pi / 3);
      final x = circleRadius * math.cos(vertex);
      final y = circleRadius * math.sin(vertex);

      if (i == 0) {
        trianglePath.moveTo(x, y);
      } else {
        trianglePath.lineTo(x, y);
      }
    }

    trianglePath.close();
    canvas.drawPath(trianglePath, trianglePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(DrawFiguresPainter oldDelegate) => oldDelegate.angle != angle;
}

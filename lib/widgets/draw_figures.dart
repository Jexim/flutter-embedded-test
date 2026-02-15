import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:test_gui/models/angle_cubit.dart';
import 'package:test_gui/utils/geometry.dart';

class DrawFigures extends StatefulWidget {
  const DrawFigures({super.key});

  @override
  State<DrawFigures> createState() => _DrawFiguresState();
}

class _DrawFiguresState extends State<DrawFigures> {
  double previousAngle = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: BlocBuilder<AngleCubit, AngleState>(
        buildWhen: (previous, current) {
          if (degrees(previousAngle - current.angle).abs() >= 1) {
            previousAngle = current.angle;

            return true;
          }

          return false;
        },
        builder:
            (context, state) => RepaintBoundary(
              child: Column(
                spacing: 16,
                children: [
                  const Text('Draw Figures', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  AspectRatio(aspectRatio: 1, child: CustomPaint(painter: DrawFiguresPainter(state.angle))),
                  SizedBox(
                    width: 300,
                    height: 64,
                    child: Column(
                      children: [
                        Text('Current Radians: ${(state.angle).toStringAsFixed(2)}'),
                        Text('Current Degrees: ${degrees(state.angle).toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
        canvas.drawCircle(Offset(x, y), 8, Paint()..color = Colors.red);
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

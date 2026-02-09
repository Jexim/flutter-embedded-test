import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:test_gui/cubit/triangle_rotation_cubit.dart';

class DrawFigures extends StatelessWidget {
  const DrawFigures({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Text('Draw Figures', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 32),
          AspectRatio(
            aspectRatio: 1,
            child: BlocBuilder<TriangleRotationCubit, double>(builder: (context, angle) => CustomPaint(painter: DrawFiguresPainter(angle))),
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

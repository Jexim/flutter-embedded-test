import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:test_gui/cubit/triangle_rotation_cubit.dart';

class DrawFigures extends StatelessWidget {
  const DrawFigures({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Text(
            'Draw Figures',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: BlocBuilder<TriangleRotationCubit, double>(
              builder:
                  (context, angle) =>
                      CustomPaint(painter: DrawFiguresPainter(angle)),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawFiguresPainter extends CustomPainter {
  final double angle;

  DrawFiguresPainter(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final circlePaint =
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.fill;
    final circleRadius = min(size.width, size.height) * 0.5 - 32;
    final circleRadiusWithPadding = circleRadius - 16;

    final trianglePaint =
        Paint()
          ..color = Colors.green
          ..style = PaintingStyle.fill;
    final trianglePath =
        Path()
          ..moveTo(
            center.dx + circleRadiusWithPadding * cos(angle),
            center.dy + circleRadiusWithPadding * sin(angle),
          )
          ..lineTo(
            center.dx + circleRadiusWithPadding * cos(angle + 2 * pi / 3),
            center.dy + circleRadiusWithPadding * sin(angle + 2 * pi / 3),
          )
          ..lineTo(
            center.dx + circleRadiusWithPadding * cos(angle + 4 * pi / 3),
            center.dy + circleRadiusWithPadding * sin(angle + 4 * pi / 3),
          )
          ..close();

    canvas.drawCircle(center, circleRadius, circlePaint);
    canvas.drawPath(trianglePath, trianglePaint);
  }

  @override
  bool shouldRepaint(DrawFiguresPainter oldDelegate) =>
      oldDelegate.angle != angle;
}

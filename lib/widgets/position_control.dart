import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:test_gui/cubit/triangle_rotation_cubit.dart';

class PositionControl extends StatelessWidget {
  const PositionControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 32, 8, 16),
      child: Column(
        children: [
          Text('Position Control', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          BlocBuilder<TriangleRotationCubit, double>(
            builder:
                (context, triangleRotation) => Column(
                  children: [
                    Slider(
                      value: triangleRotation,
                      min: -math.pi,
                      max: math.pi,
                      onChanged: (double value) {
                        context.read<TriangleRotationCubit>().setTriangleRotation(value);
                      },
                    ),
                    Text('Current Radians: ${(triangleRotation).toStringAsFixed(2)}'),
                    Text('Current Degrees: ${(triangleRotation * 180 / math.pi).toStringAsFixed(2)}'),
                  ],
                ),
          ),
        ],
      ),
    );
  }
}

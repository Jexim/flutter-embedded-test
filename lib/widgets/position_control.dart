import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:test_gui/cubit/triangle_rotation_cubit.dart';

class PositionControl extends StatelessWidget {
  const PositionControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
      child: BlocBuilder<TriangleRotationCubit, double>(
        builder:
            (context, triangleRotation) => Column(
              children: [
                Text(
                  'Position Control',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Slider(
                  value: triangleRotation,
                  max: 2 * pi,
                  onChanged: (double value) {
                    context.read<TriangleRotationCubit>().setTriangleRotation(
                      value,
                    );
                  },
                ),
                Text(
                  'Current Radians: ${(triangleRotation).toStringAsFixed(2)}',
                ),
                Text(
                  'Current Degrees: ${(triangleRotation * 180 / pi).toStringAsFixed(2)}',
                ),
              ],
            ),
      ),
    );
  }
}

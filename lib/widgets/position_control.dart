import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:test_gui/cubit/triangle_rotation_cubit.dart';

class PositionControl extends StatelessWidget {
  const PositionControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          const Text('Position Control', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Change by User'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: BlocSelector<TriangleRotationCubit, TriangleRotationState, bool>(
                        selector: (state) => state is TriangleRotationSensor,
                        builder:
                            (context, isSensor) => Switch(
                              value: isSensor,
                              onChanged: (bool value) {
                                context.read<TriangleRotationCubit>().setIsSensor(value);
                              },
                            ),
                      ),
                    ),
                    const Text('Change by Sensor'),
                  ],
                ),
              ),
              BlocSelector<TriangleRotationCubit, TriangleRotationState, ({bool isManual, double angle})>(
                selector: (s) => (isManual: s is TriangleRotationManual, angle: s.angle),
                builder:
                    (context, data) => RepaintBoundary(
                      child: Slider(
                        value: data.angle,
                        min: -math.pi,
                        max: math.pi,
                        onChanged:
                            data.isManual
                                ? (double value) {
                                  context.read<TriangleRotationCubit>().setTriangleRotation(value);
                                }
                                : null,
                      ),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

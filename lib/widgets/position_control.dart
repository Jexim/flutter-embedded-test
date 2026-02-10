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
                    const Text('Change by Sensor'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: BlocSelector<TriangleRotationCubit, TriangleRotationState, bool>(
                        selector: (s) => s.isManual,
                        builder:
                            (context, v) => Switch(
                              value: v,
                              onChanged: (bool value) {
                                context.read<TriangleRotationCubit>().setIsManual(value);
                              },
                            ),
                      ),
                    ),
                    const Text('Change by User'),
                  ],
                ),
              ),
              BlocSelector<TriangleRotationCubit, TriangleRotationState, ({double manualAngle, bool isManual})>(
                selector: (s) => (manualAngle: s.manualAngle, isManual: s.isManual),
                builder:
                    (context, state) => RepaintBoundary(
                      child: Slider(
                        value: state.manualAngle,
                        min: -math.pi,
                        max: math.pi,
                        onChanged:
                            !state.isManual
                                ? null
                                : (double value) {
                                  context.read<TriangleRotationCubit>().setTriangleRotation(value);
                                },
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

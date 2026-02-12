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
          Padding(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32), child: _AngleButtons()),
          const Text('Position Control', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Padding(padding: const EdgeInsets.all(8), child: _ModeSwitch()),
          _AngleSlider(),
        ],
      ),
    );
  }
}

class _AngleButtons extends StatelessWidget {
  const _AngleButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TriangleRotationCubit, TriangleRotationState, ({bool isManual, double angle})>(
      selector: (s) => (isManual: s is TriangleRotationManual, angle: s.angle),
      builder:
          (context, data) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed:
                    data.isManual
                        ? () {
                          context.read<TriangleRotationCubit>().setTriangleRotation((data.angle - 0.1).clamp(-math.pi, math.pi).toDouble());
                        }
                        : null,
                child: const Text('Minus 0.1 rad'),
              ),
              ElevatedButton(
                onPressed:
                    data.isManual
                        ? () {
                          context.read<TriangleRotationCubit>().setTriangleRotation(0);
                        }
                        : null,
                child: const Text('Reset'),
              ),
              ElevatedButton(
                onPressed:
                    data.isManual
                        ? () {
                          context.read<TriangleRotationCubit>().setTriangleRotation((data.angle + 0.1).clamp(-math.pi, math.pi).toDouble());
                        }
                        : null,
                child: const Text('Plus 0.1 rad'),
              ),
            ],
          ),
    );
  }
}

class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class _AngleSlider extends StatelessWidget {
  const _AngleSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TriangleRotationCubit, TriangleRotationState, ({bool isManual, double angle})>(
      selector: (s) => (isManual: s is TriangleRotationManual, angle: s.angle),
      builder:
          (context, data) => RepaintBoundary(
            child: Slider(
              key: ValueKey(data.isManual),
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
    );
  }
}

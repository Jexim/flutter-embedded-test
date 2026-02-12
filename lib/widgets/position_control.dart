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
          const SizedBox(height: 16),
          const Text('Position Control', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Padding(padding: EdgeInsets.only(top: 8), child: _ModeSwitch()),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16), child: _AngleButtons()),
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
    return BlocSelector<TriangleRotationCubit, TriangleRotationState, bool>(
      selector: (s) => s is TriangleRotationManual,
      builder: (context, isManual) {
        void setStep(double delta) {
          final angle = context.read<TriangleRotationCubit>().state.angle;
          final next = (angle + delta).clamp(-math.pi, math.pi).toDouble();

          context.read<TriangleRotationCubit>().setTriangleRotation(next);
        }

        void reset() {
          context.read<TriangleRotationCubit>().setTriangleRotation(0);
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(onPressed: isManual ? () => setStep(-0.1) : null, child: const Text('Minus 0.1 rad')),
            ElevatedButton(onPressed: isManual ? reset : null, child: const Text('Reset')),
            ElevatedButton(onPressed: isManual ? () => setStep(0.1) : null, child: const Text('Plus 0.1 rad')),
          ],
        );
      },
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

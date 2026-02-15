import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:test_gui/models/angle_cubit.dart';
import 'package:test_gui/utils/geometry.dart';

class PositionControl extends StatelessWidget {
  const PositionControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        const SizedBox(height: 16),
        const Text('Position Control', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        _ModeSwitch(),
        _AngleButtons(),
        _AngleSlider(),
      ],
    );
  }
}

class _AngleButtons extends StatelessWidget {
  const _AngleButtons();

  @override
  Widget build(BuildContext context) {
    final isManual = context.watch<AngleCubit>().state.isManual;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        ElevatedButton(
          onPressed: isManual ? () => context.read<AngleCubit>().setAngle(context.read<AngleCubit>().state.angle - radians(10)) : null,
          child: const Text('Minus 10°'),
        ),
        ElevatedButton(onPressed: isManual ? () => context.read<AngleCubit>().setAngle(0) : null, child: const Text('Reset')),
        ElevatedButton(
          onPressed: isManual ? () => context.read<AngleCubit>().setAngle(context.read<AngleCubit>().state.angle + radians(10)) : null,
          child: const Text('Plus 10°'),
        ),
      ],
    );
  }
}

class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch();

  @override
  Widget build(BuildContext context) {
    final isManual = context.watch<AngleCubit>().state.isManual;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            const Text('User'),
            Switch(
              value: !isManual,
              onChanged: (bool value) {
                context.read<AngleCubit>().setIsManual(!value);
              },
            ),
            const Text('Sensor'),
          ],
        ),
        isManual ? const Text('Change by Sensor') : const Text('Change by User'),
      ],
    );
  }
}

class _AngleSlider extends StatelessWidget {
  const _AngleSlider();

  @override
  Widget build(BuildContext context) {
    final angleState = context.watch<AngleCubit>().state;

    return RepaintBoundary(
      child: Slider(
        key: ValueKey(angleState.isManual),
        value: angleState.angle,
        min: -math.pi * 2,
        max: math.pi * 2,
        onChanged:
            angleState.isManual
                ? (double value) {
                  context.read<AngleCubit>().setAngle(value);
                }
                : null,
      ),
    );
  }
}

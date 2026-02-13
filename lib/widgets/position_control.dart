import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:test_gui/models/angle_cubit.dart';

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
    return BlocSelector<AngleCubit, AngleState, bool>(
      selector: (s) => s is AngleManual,
      builder: (context, isManual) {
        final angleCubit = context.read<AngleCubit>();

        void setStep(double delta) {
          final angle = angleCubit.state.angle;
          final next = (angle + delta * math.pi / 180).clamp(-math.pi, math.pi).toDouble();

          angleCubit.setAngle(next);
        }

        void reset() {
          angleCubit.setAngle(0);
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(onPressed: isManual ? () => setStep(-10) : null, child: const Text('Minus 10°')),
            ElevatedButton(onPressed: isManual ? reset : null, child: const Text('Reset')),
            ElevatedButton(onPressed: isManual ? () => setStep(10) : null, child: const Text('Plus 10°')),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          BlocBuilder<AngleCubit, AngleState>(
            buildWhen: (previous, current) => previous.runtimeType != current.runtimeType,
            builder:
                (context, state) => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: [
                        const Text('User'),
                        Switch(
                          value: state is AngleSensor,
                          onChanged: (bool value) {
                            context.read<AngleCubit>().setIsSensor(value);
                          },
                        ),
                        const Text('Sensor'),
                      ],
                    ),
                    switch (state) {
                      AngleSensor() => const Text('Change by Sensor'),
                      AngleManual() => const Text('Change by User'),
                    },
                  ],
                ),
          ),
        ],
      ),
    );
  }
}

class _AngleSlider extends StatelessWidget {
  const _AngleSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AngleCubit, AngleState, ({bool isManual, double angle})>(
      selector: (s) => (isManual: s is AngleManual, angle: s.angle),
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
                        context.read<AngleCubit>().setAngle(value);
                      }
                      : null,
            ),
          ),
    );
  }
}

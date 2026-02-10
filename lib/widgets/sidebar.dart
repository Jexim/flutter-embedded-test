import 'package:flutter/material.dart';

import 'package:test_gui/widgets/position_control.dart';
import 'package:test_gui/widgets/draw_figures.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(child: const Text('Button 1'), onPressed: () {}),
              ElevatedButton(child: const Text('Button 2'), onPressed: () {}),
              ElevatedButton(child: const Text('Button 3'), onPressed: () {}),
            ],
          ),
        ),
        PositionControl(),
        DrawFigures(),
      ],
    );
  }
}

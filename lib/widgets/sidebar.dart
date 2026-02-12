import 'package:flutter/material.dart';

import 'package:test_gui/widgets/position_control.dart';
import 'package:test_gui/widgets/draw_figures.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [PositionControl(), DrawFigures()]);
  }
}

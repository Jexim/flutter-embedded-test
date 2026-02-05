import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:test_gui/widgets/main_stream.dart';
import 'package:test_gui/widgets/position_control.dart';
import 'package:test_gui/widgets/draw_figures.dart';
import 'package:test_gui/cubit/triangle_rotation_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test GUI',
      home: Scaffold(
        body: Row(
          children: [
            AspectRatio(aspectRatio: 4 / 3, child: MainStream()),
            Expanded(
              child: BlocProvider(
                create: (_) => TriangleRotationCubit(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [PositionControl(), DrawFigures()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

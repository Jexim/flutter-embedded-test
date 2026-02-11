import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:test_gui/widgets/main_stream.dart';
import 'package:test_gui/widgets/sidebar.dart';
import 'package:test_gui/cubit/triangle_rotation_cubit.dart';

void main() {
  if (kDebugMode) {
    debugRepaintRainbowEnabled = true;
    // debugPrintMarkNeedsPaintStacks = true;
    // debyugPrintRebuildDirtyWidgets = true;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test GUI',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
        ),
      ),
      home: BlocProvider(
        create: (_) => TriangleRotationCubit()..start(),
        child: Scaffold(body: Row(children: [AspectRatio(aspectRatio: 4 / 3, child: MainStream()), Expanded(child: Sidebar())])),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:test_gui/models/angle_cubit.dart';
import 'package:test_gui/widgets/main_stream.dart';
import 'package:test_gui/widgets/sidebar.dart';

void main() {
  if (kDebugMode) {
    debugRepaintRainbowEnabled = true;
    // debugPrintMarkNeedsPaintStacks = true;
    // debugPrintRebuildDirtyWidgets = true;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test GUI',
      home: BlocProvider(
        create: (context) => AngleCubit(),
        child: Scaffold(body: Row(children: [AspectRatio(aspectRatio: 4 / 3, child: MainStream()), Expanded(child: Sidebar())])),
      ),
    );
  }
}

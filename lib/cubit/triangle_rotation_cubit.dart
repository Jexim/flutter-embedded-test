import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import 'package:test_gui/services/udp_sensor.dart';

class TriangleRotationCubit extends Cubit<double> {
  TriangleRotationCubit() : super(0);

  final UdpSensorService _udpSensorService = UdpSensorService();
  StreamSubscription<double>? _streamSubscription;
  DateTime? _lastEmitTime;

  Future<void> start() async {
    try {
      await _udpSensorService.start();

      _streamSubscription ??= _udpSensorService.stream.listen((value) {
        if (_lastEmitTime != null && DateTime.now().difference(_lastEmitTime!).inSeconds < 1) {
          return;
        }

        _lastEmitTime = DateTime.now();

        emit(value);
      });
    } catch (e, st) {
      debugPrint('$e\n$st');
    }
  }

  void setTriangleRotation(double triangleRotation) {
    emit(triangleRotation);
  }

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    await _udpSensorService.dispose();

    return super.close();
  }
}

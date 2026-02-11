import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import 'package:test_gui/services/udp_sensor.dart';

final class TriangleRotationState {
  final double sensorAngle;
  final double manualAngle;
  final bool isManual;

  TriangleRotationState({required this.sensorAngle, required this.isManual, required this.manualAngle});
}

class TriangleRotationCubit extends Cubit<TriangleRotationState> {
  TriangleRotationCubit() : super(TriangleRotationState(sensorAngle: 0, isManual: false, manualAngle: 0));

  final UdpSensorService _udpSensorService = UdpSensorService();
  StreamSubscription<double>? _streamSubscription;
  DateTime? _lastEmitTime;

  Future<void> start() async {
    try {
      await _udpSensorService.start();

      _streamSubscription ??= _udpSensorService.stream.listen((value) {
        if (state.isManual) return;
        if (_lastEmitTime != null && DateTime.now().difference(_lastEmitTime!).inMilliseconds < 1000) {
          return;
        }

        _lastEmitTime = DateTime.now();

        emit(TriangleRotationState(sensorAngle: value, isManual: state.isManual, manualAngle: state.manualAngle));
      });
    } catch (e, st) {
      debugPrint('$e\n$st');
    }
  }

  void setTriangleRotation(double triangleRotation) {
    emit(TriangleRotationState(manualAngle: triangleRotation, sensorAngle: state.sensorAngle, isManual: state.isManual));
  }

  void setIsManual(bool isManual) {
    emit(TriangleRotationState(isManual: isManual, sensorAngle: state.sensorAngle, manualAngle: state.manualAngle));
  }

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    await _udpSensorService.dispose();

    return super.close();
  }
}

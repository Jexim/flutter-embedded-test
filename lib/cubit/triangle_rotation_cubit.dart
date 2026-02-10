import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import 'package:test_gui/services/udp_sensor.dart';

final class TriangleRotationState {
  final double angle;
  final bool isManual;

  TriangleRotationState({required this.angle, required this.isManual});
}

class TriangleRotationCubit extends Cubit<TriangleRotationState> {
  TriangleRotationCubit() : super(TriangleRotationState(angle: 0, isManual: false));

  final UdpSensorService _udpSensorService = UdpSensorService();
  StreamSubscription<double>? _streamSubscription;
  DateTime? _lastEmitTime;

  Future<void> start() async {
    try {
      await _udpSensorService.start();

      _streamSubscription ??= _udpSensorService.stream.listen((value) {
        if (state.isManual) return;
        if (_lastEmitTime != null && DateTime.now().difference(_lastEmitTime!).inSeconds < 1) {
          return;
        }

        _lastEmitTime = DateTime.now();

        emit(TriangleRotationState(angle: value, isManual: state.isManual));
      });
    } catch (e, st) {
      debugPrint('$e\n$st');
    }
  }

  void setTriangleRotation(double triangleRotation) {
    emit(TriangleRotationState(angle: triangleRotation, isManual: state.isManual));
  }

  void setIsManual(bool isManual) {
    emit(TriangleRotationState(angle: state.angle, isManual: isManual));
  }

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    await _udpSensorService.dispose();

    return super.close();
  }
}

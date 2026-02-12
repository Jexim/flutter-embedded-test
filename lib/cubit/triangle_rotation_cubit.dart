import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

import 'package:test_gui/services/udp_sensor.dart';

sealed class TriangleRotationState extends Equatable {
  final double angle;

  const TriangleRotationState({required this.angle});

  @override
  List<Object?> get props => [angle];
}

final class TriangleRotationManual extends TriangleRotationState {
  const TriangleRotationManual({required super.angle});

  @override
  String toString() => 'TriangleRotationManual { angle: $angle }';
}

final class TriangleRotationSensor extends TriangleRotationState {
  const TriangleRotationSensor({required super.angle});

  @override
  String toString() => 'TriangleRotationSensor { angle: $angle }';
}

class TriangleRotationCubit extends Cubit<TriangleRotationState> {
  TriangleRotationCubit() : super(const TriangleRotationManual(angle: 0));

  final UdpSensorService _udpSensorService = UdpSensorService();
  StreamSubscription<double>? _streamSubscription;
  DateTime? _lastEmitTime;

  Future<void> start() async {
    try {
      await _udpSensorService.start();

      _streamSubscription ??= _udpSensorService.stream.listen((value) {
        if (state is TriangleRotationManual) return;
        if (_lastEmitTime != null && DateTime.now().difference(_lastEmitTime!).inMilliseconds < 1000) {
          return;
        }

        _lastEmitTime = DateTime.now();

        emit(TriangleRotationSensor(angle: value.clamp(-math.pi, math.pi).toDouble()));
      });
    } catch (e, st) {
      debugPrint('$e\n$st');
    }
  }

  void setTriangleRotation(double angle) {
    emit(TriangleRotationManual(angle: angle.clamp(-math.pi, math.pi).toDouble()));
  }

  void setIsSensor(bool isSensor) {
    emit(isSensor ? TriangleRotationSensor(angle: state.angle) : TriangleRotationManual(angle: state.angle));
  }

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    await _udpSensorService.dispose();

    return super.close();
  }
}

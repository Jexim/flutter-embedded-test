import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:test_gui/io/udp_angle_sensor.dart';

sealed class AngleState extends Equatable {
  final double angle;

  const AngleState({required this.angle});

  @override
  List<Object?> get props => [angle];
}

final class AngleManual extends AngleState {
  const AngleManual({required super.angle});

  @override
  String toString() => 'AngleManual { angle: $angle }';
}

final class AngleSensor extends AngleState {
  const AngleSensor({required super.angle});

  @override
  String toString() => 'AngleSensor { angle: $angle }';
}

class AngleCubit extends Cubit<AngleState> {
  AngleCubit(this._angleSensorRepository) : super(const AngleManual(angle: 0));

  final AngleSensorRepository _angleSensorRepository;
  StreamSubscription<double>? _streamSubscription;

  void setAngle(double angle) {
    emit(AngleManual(angle: angle.clamp(-math.pi, math.pi).toDouble()));
  }

  Future<void> setIsSensor(bool isSensor) async {
    emit(isSensor ? AngleSensor(angle: state.angle) : AngleManual(angle: state.angle));

    if (isSensor) {
      await startListeningSensor();
    } else {
      await stopListeningSensor();
    }
  }

  Future<void> startListeningSensor() async {
    await _angleSensorRepository.start();

    _streamSubscription ??= _angleSensorRepository.stream.listen((value) {
      if (state is! AngleSensor) return;

      emit(AngleSensor(angle: value));
    });
  }

  Future<void> stopListeningSensor() async {
    await _streamSubscription?.cancel();
    _streamSubscription = null;
    await _angleSensorRepository.stop();
  }

  @override
  Future<void> close() async {
    await stopListeningSensor();

    return super.close();
  }
}

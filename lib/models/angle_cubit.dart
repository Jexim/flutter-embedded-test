import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:test_gui/io/udp_angle_sensor.dart';

class AngleState extends Equatable {
  final double angle;
  final bool isManual;

  const AngleState({required this.angle, required this.isManual});

  @override
  List<Object?> get props => [angle, isManual];

  AngleState copyWith({double? angle, bool? isManual}) {
    return AngleState(angle: angle ?? this.angle, isManual: isManual ?? this.isManual);
  }
}

class AngleCubit extends Cubit<AngleState> {
  AngleCubit() : super(const AngleState(angle: 0, isManual: true));

  StreamSubscription<double>? _streamSubscription;

  void setAngle(double angle) {
    if (!state.isManual) return;

    emit(state.copyWith(angle: angle.clamp(-math.pi * 2, math.pi * 2).toDouble()));
  }

  Future<void> setIsManual(bool isManual) async {
    emit(state.copyWith(isManual: isManual));

    if (isManual) {
      await _closeStream();
    } else {
      await _openStream();
    }
  }

  Future<void> _openStream() async {
    _streamSubscription ??= UdpAngleSensorReader().listen((value) {
      if (state.isManual) return;

      emit(state.copyWith(angle: value));
    });
  }

  Future<void> _closeStream() async {
    await _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  @override
  Future<void> close() async {
    await _closeStream();

    return super.close();
  }
}

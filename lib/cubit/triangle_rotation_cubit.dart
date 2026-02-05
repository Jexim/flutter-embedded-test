import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriangleRotationCubit extends Cubit<double> {
  TriangleRotationCubit() : super(pi / 6); // 30 degrees by default

  void setTriangleRotation(double triangleRotation) {
    emit(triangleRotation);
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';

class TriangleRotationCubit extends Cubit<double> {
  TriangleRotationCubit() : super(0);

  void setTriangleRotation(double triangleRotation) {
    emit(triangleRotation);
  }
}

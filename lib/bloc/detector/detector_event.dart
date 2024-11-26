import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

abstract class DetectorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitializeModelEvent extends DetectorEvent {}

class RunModelEvent extends DetectorEvent {
  final CameraImage image;

  RunModelEvent(this.image);

  @override
  List<Object?> get props => [image];
}
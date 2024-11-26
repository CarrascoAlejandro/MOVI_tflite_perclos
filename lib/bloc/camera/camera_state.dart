import 'package:equatable/equatable.dart';
import 'package:camera/camera.dart';

// States
abstract class CameraState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CameraInitialState extends CameraState {}

class CameraLoadingState extends CameraState {}

class CameraReadyState extends CameraState {
  final CameraController controller;

  CameraReadyState(this.controller);

  @override
  List<Object?> get props => [controller];
}

class CameraPictureTakenState extends CameraState {
  final String imagePath;

  CameraPictureTakenState(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class CameraErrorState extends CameraState {
  final String message;

  CameraErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class CameraStreamingState extends CameraState {
  final CameraController controller;

  CameraStreamingState(this.controller);

  @override
  List<Object?> get props => [controller];
}

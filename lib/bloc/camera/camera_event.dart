import 'package:equatable/equatable.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

// Events
abstract class CameraEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitializeCameraEvent extends CameraEvent {
  final CameraDescription camera;

  InitializeCameraEvent(this.camera);

  @override
  List<Object?> get props => [camera];
}

class TakePictureEvent extends CameraEvent {}

class StartImageStreamEvent extends CameraEvent {
  final BuildContext context;

  StartImageStreamEvent(this.context);

  @override
  List<Object?> get props => [context];
}

class CameraStreamingEvent extends CameraEvent {
  final CameraController controller;

  CameraStreamingEvent(this.controller);

  @override
  List<Object?> get props => [controller];
}

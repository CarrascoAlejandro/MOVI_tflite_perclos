import 'dart:io';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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

class PickImageDetectEvent extends DetectorEvent {
  BuildContext context;
  final File image;

  PickImageDetectEvent(this.context, this.image);

  @override
  List<Object?> get props => [context, image];
}
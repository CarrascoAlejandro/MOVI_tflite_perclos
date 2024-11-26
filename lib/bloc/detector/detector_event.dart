import 'dart:ui';

import 'package:equatable/equatable.dart';

abstract class DetectorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadModelEvent extends DetectorEvent {}

class RunModelEvent extends DetectorEvent {
  final Image image;

  RunModelEvent(this.image);

  @override
  List<Object?> get props => [image];
}
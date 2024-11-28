import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class PickImageEvent extends ImageEvent {
  final BuildContext context;

  const PickImageEvent(this.context);

  @override
  List<Object> get props => [context];
}
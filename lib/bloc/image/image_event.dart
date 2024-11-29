import 'dart:io';

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

class ImageProcessedEvent extends ImageEvent {
  final BuildContext context;
  final File image;

  const ImageProcessedEvent(this.context, this.image);

  @override
  List<Object> get props => [context, image];
}

class ImageErrorEvent extends ImageEvent {
  final String error;

  const ImageErrorEvent(this.error);

  @override
  List<Object> get props => [error];
}

class ResetImageEvent extends ImageEvent {}
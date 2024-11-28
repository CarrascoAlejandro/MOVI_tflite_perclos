import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}

class ImageInitialState extends ImageState {}

class ImagePickedState extends ImageState {
  final File image;

  const ImagePickedState(this.image);

  @override
  List<Object> get props => [image];
}

class ImageProcessedState extends ImageState {
  final File image;

  const ImageProcessedState(this.image);

  @override
  List<Object> get props => [image];
}

class ImageErrorState extends ImageState {
  final String error;

  const ImageErrorState(this.error);

  @override
  List<Object> get props => [error];
}
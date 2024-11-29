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
  final int width;
  final int height;

  const ImageProcessedState(this.image, this.width, this.height);

  @override
  List<Object> get props => [image, width, height];
}

class ImageErrorState extends ImageState {
  final String error;

  const ImageErrorState(this.error);

  @override
  List<Object> get props => [error];
}
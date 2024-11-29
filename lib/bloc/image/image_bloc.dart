import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_test_run/bloc/detector/detector_bloc.dart';
import 'package:flutter_camera_test_run/bloc/detector/detector_event.dart';
import 'package:image_picker/image_picker.dart';
import 'image_event.dart';
import 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImagePicker _picker = ImagePicker();

  ImageBloc() : super(ImageInitialState()){
    on<PickImageEvent>(_onPickImage);
    on<ImageProcessedEvent>(_onImageProcessed);
    on<ImageErrorEvent>(_onImageError);
    on<ResetImageEvent>(_onResetImage);
  }

  Future<void> _onPickImage(PickImageEvent event, Emitter<ImageState> emit) async {
    print("ALECAR: _onPickImage awaiting image");
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      print("ALECAR: _onPickImage image picked ${pickedFile.path}");
      BlocProvider.of<DetectorBloc>(event.context).add(PickImageDetectEvent(event.context, image));
      emit(ImagePickedState(image));
    } else {
      print("ALECAR: _onPickImage no image picked");
      emit(ImageErrorState("No image picked"));
    }
  }

  Future<void> _onImageProcessed(ImageProcessedEvent event, Emitter<ImageState> emit) async {
    emit(ImageProcessedState(event.image));
  }

  Future<void> _onImageError(ImageErrorEvent event, Emitter<ImageState> emit) async {
    emit(ImageErrorState(event.error));
  }

  Future<void> _onResetImage(ResetImageEvent event, Emitter<ImageState> emit) async {
    emit(ImageInitialState());
  }
}
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
  }

  Future<void> _onPickImage(PickImageEvent event, Emitter<ImageState> emit) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      emit(ImagePickedState(image));
      
      BlocProvider.of<DetectorBloc>(event.context).add(PickImageDetectEvent(image));

      emit(ImageProcessedState(image));
    }
  }
}
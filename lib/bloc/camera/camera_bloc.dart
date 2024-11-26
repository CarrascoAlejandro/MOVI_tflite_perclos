import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter_camera_test_run/bloc/detector/detector_event.dart';
import 'package:flutter_camera_test_run/bloc/detector/detector_bloc.dart';

import 'camera_event.dart';
import 'camera_state.dart';

// Bloc
class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraController? _controller;

  CameraBloc() : super(CameraInitialState()) {
    on<InitializeCameraEvent>(_onInitializeCamera);
    on<TakePictureEvent>(_onTakePicture);
    on<StartImageStreamEvent>(_onStartImageStreamEvent);
  }

  Future<void> _onInitializeCamera(
      InitializeCameraEvent event, 
      Emitter<CameraState> emit
  ) async {
    print("Initializing camera");
    emit(CameraLoadingState());
    print("Camera initialized");
    try {
      _controller = CameraController(event.camera, ResolutionPreset.medium);
      await _controller!.initialize();
      emit(CameraReadyState(_controller!));
    } catch (e) {
      emit(CameraErrorState('Failed to initialize camera: $e'));
    }
  }

  Future<void> _onTakePicture(
      TakePictureEvent event, Emitter<CameraState> emit) async {
    if (_controller == null || !_controller!.value.isInitialized) {
      emit(CameraErrorState('Camera not initialized'));
      return;
    }

    try {
      final image = await _controller!.takePicture();
      emit(CameraPictureTakenState(image.path));
      emit(CameraReadyState(_controller!));
    } catch (e) {
      emit(CameraErrorState('Failed to take picture: $e'));
    }
  }

  Future<void> _onStartImageStreamEvent(
    StartImageStreamEvent event, Emitter<CameraState> emit
  ) async {
    if (_controller == null || !_controller!.value.isInitialized) {
      emit(CameraErrorState('Camera not initialized'));
      return;
    }
    print("Starting image stream");

    try {
      await _controller!.startImageStream((CameraImage image){
        // This function is called every time a new frame is available
        print("Image stream received: ${image.planes.length}");

        BlocProvider.of<DetectorBloc>(event.context).add(RunModelEvent(image));
      });
      emit(CameraStreamingState(_controller!));
    } catch (e) {
      emit(CameraErrorState('Failed to start image stream: $e'));
    }
  }

  @override
  Future<void> close() {
    _controller?.dispose();
    return super.close();
  }
}

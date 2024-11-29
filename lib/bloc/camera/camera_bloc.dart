import 'dart:async';
import 'dart:io';

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
      InitializeCameraEvent event, Emitter<CameraState> emit) async {
    print("ALECAR: Initializing camera");
    emit(CameraLoadingState());
    try {
      _controller = CameraController(
        event.camera,
        ResolutionPreset.medium,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );
      await _controller!.initialize();
      emit(CameraReadyState(_controller!));
      print("ALECAR: Camera initialized");
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
      StartImageStreamEvent event, Emitter<CameraState> emit) async {
    if (_controller == null || !_controller!.value.isInitialized) {
      emit(CameraErrorState('Camera not initialized'));
      return;
    }
    print("ALECAR: Starting image stream");
    print("ALECAR: Image format: ${_controller!.imageFormatGroup}");

    try {
      final detectorBloc = BlocProvider.of<DetectorBloc>(event.context);
      bool isCapturing = false;
      await _controller!.startImageStream((CameraImage image) async {
        // This function is called every time a new frame is available
        if (isCapturing) return;
        isCapturing = true;
        try {
          var image = await _controller!.takePicture();
          detectorBloc.add(PickImageDetectEvent(event.context, File(image.path)));
        } catch (e) {
          print("ALECAR: Error capturing image: $e");
        } finally {
          isCapturing = false;
        }
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

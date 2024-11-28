import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter_camera_test_run/bloc/detector/detector_event.dart';
import 'package:flutter_camera_test_run/bloc/detector/detector_state.dart';
import 'package:google_ml_kit/google_ml_kit.dart';


class DetectorBloc extends Bloc<DetectorEvent, DetectorState> {
  InputImage? _inputImage;
  FaceDetector? _faceDetector;

  DetectorBloc() : super(DetectorInitialState()) {
    on<InitializeModelEvent>(_onInitializeModel);
    on<RunModelEvent>(_onRunModel);
  }

  Future<void> _onInitializeModel(
      InitializeModelEvent event, Emitter<DetectorState> emit) async {
    print("ALECAR: Initializing detector");

    FaceDetectorOptions options = FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    );

    _faceDetector = GoogleMlKit.vision.faceDetector(options);
  }

  Future<void> _onRunModel(
      RunModelEvent event, Emitter<DetectorState> emit) async {
    try {
      CameraImage cameraImage = event.image;

      // Convert the camera image to a format that the interpreter can understand
      _inputImage = InputImage.fromBytes(
        bytes: cameraImage.planes[0].bytes,
        metadata: InputImageMetadata(
          size: Size(cameraImage.width.toDouble(), cameraImage.height.toDouble()),
          rotation: InputImageRotation.rotation0deg,
          format: InputImageFormat.nv21,
          bytesPerRow: cameraImage.planes[0].bytesPerRow,
          )
      );

      // Run the model
      List<Face> faces = await _faceDetector!.processImage(_inputImage!);

      print("ALECAR: Found ${faces.length} faces");

      // Emit the results
      emit(DetectorResultState(faces.first));
    } catch (e) {
      print("ALECAR: Error running model: $e");
      emit(DetectorErrorState("Error running model: $e"));
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}

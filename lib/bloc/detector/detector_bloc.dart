import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_test_run/bloc/detector/detector_event.dart';
import 'package:flutter_camera_test_run/bloc/detector/detector_state.dart';
import 'package:flutter_camera_test_run/bloc/image/image_bloc.dart';
import 'package:flutter_camera_test_run/bloc/image/image_event.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class DetectorBloc extends Bloc<DetectorEvent, DetectorState> {
  InputImage? _inputImage;
  FaceDetector? _faceDetector;
  int _alarmCount = 0;

  DetectorBloc() : super(DetectorInitialState()) {
    on<InitializeModelEvent>(_onInitializeModel);
    on<RunModelEvent>(_onRunModel);
    on<PickImageDetectEvent>(_onPickImageEvent);
  }

  Future<void> _onInitializeModel(
      InitializeModelEvent event, Emitter<DetectorState> emit) async {
    print("ALECAR: Initializing detector");

    FaceDetectorOptions options = FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      enableClassification: true,
      enableTracking: true,
    );

    _faceDetector = GoogleMlKit.vision.faceDetector(options);

    _alarmCount = 0;
  }

  Future<void> _onRunModel(
      RunModelEvent event, Emitter<DetectorState> emit) async {
    try {
      CameraImage cameraImage = event.image;

      // Convert the camera image to a format that the interpreter can understand
      _inputImage = InputImage.fromBytes(
          bytes: cameraImage.planes[0].bytes,
          metadata: InputImageMetadata(
            size: Size(
                cameraImage.width.toDouble(), cameraImage.height.toDouble()),
            rotation: InputImageRotation.rotation0deg,
            format: InputImageFormat.nv21,
            bytesPerRow: cameraImage.planes[0].bytesPerRow,
          ));

      // Run the model
      List<Face> faces = await _faceDetector!.processImage(_inputImage!);

      print("ALECAR: Found ${faces.length} faces");

      // Emit the results
      if (!faces.isEmpty) emit(DetectorResultState(faces.first));
    } catch (e) {
      print("ALECAR: Error running model: $e");
      emit(DetectorErrorState("Error running model: $e"));
    }
  }

  Future<void> _onPickImageEvent(
      PickImageDetectEvent event, Emitter<DetectorState> emit) async {
    try {
      _inputImage = InputImage.fromFile(event.image);

      print("ALECAR: Running model on image ${event.image.path}");

      // Run the model
      List<Face> faces = await _faceDetector!.processImage(_inputImage!);

      print("ALECAR: Found ${faces.length} faces");

      // Add a ProcessedImageEvent to the ImageBloc
      BlocProvider.of<ImageBloc>(event.context)
          .add(ImageProcessedEvent(event.context, event.image));

      // Emit the results
      if (faces.isEmpty) {
        print("ALECAR: No faces found");
        emit(DetectorErrorState("No faces found"));
      } else {
        // Emit the results
        if (!faces.isEmpty) {
          print("ALECAR: Current alarm count: $_alarmCount");
          if (faces.first.leftEyeOpenProbability == null ||
              faces.first.rightEyeOpenProbability == null) {
            emit(DetectorErrorState("No eye probabilities found"));
          } else if ((faces.first.leftEyeOpenProbability! +
                  faces.first.rightEyeOpenProbability!) <
              0.6) {
            _alarmCount++;
            if (_alarmCount > 5) {
              playSound();
              vibratePhone();
              emit(DetectorErrorState("Drowsiness detected"));
              return;
            }
          } else {
            _alarmCount--;
          }
          emit(DetectorResultState(faces.first));
        }
      }
    } catch (e) {
      print("ALECAR: Error running model: $e");
      emit(DetectorErrorState("Error running model: $e"));
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }

  void playSound() async {
    final player = AudioPlayer();
    await player.play(AssetSource('ringing-ringtone-40821.mp3'));
  }

  void vibratePhone() async {
    if ((await Vibration.hasVibrator()) ?? false) {
      Vibration.vibrate(duration: 1000); // Vibrate for 1 second
    }
  }
}

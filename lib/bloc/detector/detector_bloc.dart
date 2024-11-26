import 'package:bloc/bloc.dart';
import 'package:flutter_camera_test_run/bloc/detector/detector_event.dart';
import 'package:flutter_camera_test_run/bloc/detector/detector_state.dart';
import 'package:flutter_camera_test_run/util/image_utils.dart';
import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class DetectorBloc extends Bloc<DetectorEvent, DetectorState>{
  Interpreter? _interpreter;

  DetectorBloc() : super(DetectorInitialState()) {
    on<InitializeModelEvent>(_onInitializeModel);
    on<RunModelEvent>(_onRunModel);
  }

  Future<void> _onInitializeModel(InitializeModelEvent event, Emitter<DetectorState> emit) async {
    print("Initializing detector");
    emit(DetectorLoadingState());
    try {
      _interpreter = await Interpreter.fromAsset('assets/facial_landmark_MobileNet.tflite');
      emit(DetectorModelLoadedState());
      print("Model loaded");
    } catch (e) {
      emit(DetectorErrorState("Failed to load model"));
    }
  }

  Future<void> _onRunModel(RunModelEvent event, Emitter<DetectorState> emit) async {
    if(_interpreter == null){
      emit(DetectorErrorState("Model not loaded"));
      return;
    }
    //print("Running model");

    try {
      var input = event.image;
      var output = List.filled(1, List.filled(1, 0.0));
      
      //convert the input to an appropriate format
      //print("Converting image");
      Image? convertedInput = convertCameraImage(input);
      if(convertedInput == null){
        emit(DetectorErrorState("Failed to convert image"));
        return;
      }
      // Convert the Image to a float32 tensor
      var inputTensor = imageToFloat32Tensor(convertedInput);

      //run the model
      _interpreter!.run(inputTensor, output);
      print("Emitting result");
      emit(DetectorResultState(output));
    } catch (e) {
      print("Error running model: $e");
      emit(DetectorErrorState('Failed to run model: $e'));
    }
  }

  @override
  Future<void> close() {
    _interpreter?.close();
    return super.close();
  }

}
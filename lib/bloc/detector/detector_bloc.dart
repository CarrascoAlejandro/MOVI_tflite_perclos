import 'package:bloc/bloc.dart';
import 'package:flutter_camera_test_run/bloc/detector/detector_event.dart';
import 'package:flutter_camera_test_run/bloc/detector/detector_state.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class DetectorBloc extends Bloc<DetectorEvent, DetectorState>{
  Interpreter? _interpreter;

  DetectorBloc() : super(DetectorInitialState()) {
    on<LoadModelEvent>(_onLoadModel);
    on<RunModelEvent>(_onRunModel);
  }

  Future<void> _onLoadModel(LoadModelEvent event, Emitter<DetectorState> emit) async {
    print("Loading model");
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
    print("Running model");

    try {
      var input = event.image;
      var output;
      
      _interpreter!.run(input, output);
      print("Emitting result");
      emit(DetectorResultState(output));
    } catch (e) {
      emit(DetectorErrorState('Failed to run model: $e'));
    }
  }

  @override
  Future<void> close() {
    _interpreter?.close();
    return super.close();
  }

}
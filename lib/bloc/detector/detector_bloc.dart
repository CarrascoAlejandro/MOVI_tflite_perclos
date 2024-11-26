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
    emit(DetectorLoadingState());
    try {
      _interpreter = await Interpreter.fromAsset('assets/facial_landmark_MobileNet.tflite');
      emit(DetectorModelLoadedState());
    } catch (e) {
      emit(DetectorErrorState("Failed to load model"));
    }
  }

  Future<void> _onRunModel(RunModelEvent event, Emitter<DetectorState> emit) async {
    if(_interpreter == null){
      emit(DetectorErrorState("Model not loaded"));
      return;
    }

    try {
      var input = event.image;
      var output;
      
      _interpreter!.run(input, output);

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
import 'package:equatable/equatable.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

abstract class DetectorState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DetectorInitialState extends DetectorState {}

class DetectorLoadingState extends DetectorState {}

class DetectorModelLoadedState extends DetectorState {}

class DetectorResultState extends DetectorState {
  final Face output;

  DetectorResultState(this.output);

  @override
  List<Object?> get props => [output]; 
}

class DetectorErrorState extends DetectorState {
  final String message;

  DetectorErrorState(this.message);

  @override
  List<Object?> get props => [message]; 
}
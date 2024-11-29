import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_test_run/bloc/detector/detector_bloc.dart';
import 'package:flutter_camera_test_run/bloc/detector/detector_event.dart';
import 'package:flutter_camera_test_run/bloc/detector/detector_state.dart';
import 'package:flutter_camera_test_run/bloc/image/image_bloc.dart';
import 'package:flutter_camera_test_run/bloc/image/image_event.dart';
import 'package:flutter_camera_test_run/bloc/image/image_state.dart';
import 'package:flutter_camera_test_run/widget/how_it_works.dart';
import 'package:flutter_camera_test_run/widget/results_component.dart';

class PickImageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<DetectorBloc>().add(InitializeModelEvent());

    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Image'),
      ),
      body: Center(
        child: BlocBuilder<ImageBloc, ImageState>(
          builder: (context, state) {
            if (state is ImageInitialState) {
              return buildInitialInput(context);
            } else if (state is ImagePickedState) {
              return buildImageDisplay(context, state.image);
            } else if (state is ImageErrorState) {
              return Text(state.error);
            } else if (state is ImageProcessedState) {
              return buildImageResult(context, state.image);
            } else {
              return Container();
            }
          },
        ),
      ),
      floatingActionButton: BlocBuilder<ImageBloc, ImageState>(
          builder: (context, state) {
            if (state is! ImageInitialState) {
              return FloatingActionButton(
                onPressed: () {
                  BlocProvider.of<ImageBloc>(context).add(ResetImageEvent());
                },
                child: Icon(Icons.refresh),
              );
            } else {
              return Container();
            }
        },
      ),
    );
  }

  Widget buildInitialInput(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/face_landmarks.png', height: 180),
        HowItWorks(),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            BlocProvider.of<ImageBloc>(context).add(PickImageEvent(context));
          },
          child: Text('Pick Image'),
        ),
      ],
    );
  }

  Widget buildImageDisplay(BuildContext context, File image) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.file(image),
        SizedBox(height: 20),
        CircularProgressIndicator(),
      ],
    );
  }

  Widget buildImageResult(BuildContext context, File image) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Image.file(image),
        ),
        SizedBox(height: 20),
        BlocBuilder<DetectorBloc, DetectorState>(
          builder: (context, state) {
            Widget detectorWidget = Container();
            if (state is DetectorResultState) {
              detectorWidget = ResultsComponent(
                value1: state.output.leftEyeOpenProbability,
                value2: state.output.rightEyeOpenProbability,
                value1label: 'Left Eye',
                value2label: 'Right Eye',
              );
            } else if (state is DetectorErrorState) {
              detectorWidget = Text(state.message);
            } else {
              detectorWidget = Text('Processing...');
            }

            return detectorWidget;
          },
        ),
      ],
    );
  }
}

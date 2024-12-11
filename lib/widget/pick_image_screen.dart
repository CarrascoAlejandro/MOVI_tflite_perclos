import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_test_run/bloc/detector/detector_bloc.dart';
import 'package:flutter_camera_test_run/bloc/detector/detector_event.dart';
import 'package:flutter_camera_test_run/bloc/detector/detector_state.dart';
import 'package:flutter_camera_test_run/bloc/image/image_bloc.dart';
import 'package:flutter_camera_test_run/bloc/image/image_event.dart';
import 'package:flutter_camera_test_run/bloc/image/image_state.dart';
import 'package:flutter_camera_test_run/painter/face_landmark_painter.dart';
import 'package:flutter_camera_test_run/widget/error_component.dart';
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
              return buildImageResult(
                  context, state.image, state.width, state.height);
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
              backgroundColor: Colors.white,
              foregroundColor: Colors.teal,
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.teal,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            BlocProvider.of<ImageBloc>(context).add(PickImageEvent(context));
          },
          child: Text('Pick Image', style: TextStyle(fontSize: 20)),
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

  Widget buildImageResult(
      BuildContext context, File image, int width, int height) {
    //final double width_relative = width / 100;
    final Image imageWidget = Image.file(image);

    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<DetectorBloc, DetectorState>(
          builder: (context, state) {
            if (state is DetectorResultState) {
              print("ALECAR: PickImageScreen Painting landmarks");
              return Stack(
                children: [
                  imageWidget,
                  /* CustomPaint(
                    size: Size(width.toDouble(), height.toDouble()),
                    painter: FaceLandmarkPainter(
                      landmarks: state.output.landmarks
                    ),
                  ), */
                ],
              );
            } else {
              return imageWidget;
            }
          },
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
              detectorWidget =
                  Center(child: ErrorComponent(errorMessage: state.message));
            } else {
              detectorWidget = Text('Processing...');
            }

            return detectorWidget;
          },
        ),
      ],
    ));
  }
}

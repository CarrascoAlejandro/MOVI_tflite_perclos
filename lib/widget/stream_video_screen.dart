import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_test_run/bloc/camera/camera_bloc.dart';
import 'package:flutter_camera_test_run/bloc/camera/camera_event.dart';
import 'package:flutter_camera_test_run/bloc/camera/camera_state.dart';
import 'package:flutter_camera_test_run/bloc/detector/detector_bloc.dart';
import 'package:flutter_camera_test_run/bloc/detector/detector_event.dart';
import 'package:flutter_camera_test_run/bloc/detector/detector_state.dart';
import 'package:flutter_camera_test_run/widget/error_component.dart';
import 'package:flutter_camera_test_run/widget/results_component.dart';

class StreamVideoScreen extends StatelessWidget {
  final CameraDescription camera;
  const StreamVideoScreen({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    context.read<CameraBloc>().add(InitializeCameraEvent(camera));
    context.read<DetectorBloc>().add(InitializeModelEvent());

    return Scaffold(
      appBar: AppBar(title: const Text('Stream Video')),
      body: BlocBuilder<CameraBloc, CameraState>(
        builder: (context, state) {
          if (state is CameraLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CameraReadyState) {
            return Column(
              children: [
                const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: CameraPreview(state.controller),
                  ),
                  const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<CameraBloc>()
                        .add(StartImageStreamEvent(context));
                  },
                  child: const Text('Start Image Stream'),
                ),
                BlocListener<DetectorBloc, DetectorState>(
                  listener: (context, state) {
                    if (state is DetectorResultState) {
                      print("Model output: ${state.output}");
                    }
                  },
                  child: Container(),
                )
              ],
            );
          } else if (state is CameraStreamingState) {
            return Column(
              children: [
                const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: CameraPreview(state.controller),
                  ),
                  const SizedBox(height: 20),
                BlocBuilder<DetectorBloc, DetectorState>(
                  builder: (context, state) {
                    Widget detectorWidget = Container();
                    if (state is DetectorResultState) {
                      detectorWidget =
                          Center(child: ResultsComponent(
                            value1: state.output.leftEyeOpenProbability, 
                            value2: state.output.rightEyeOpenProbability,
                            value1label: 'Left Eye',
                            value2label: 'Right Eye',
                          ));
                    } else if (state is DetectorErrorState) {
                      detectorWidget = Center(child: ErrorComponent(errorMessage: state.message));
                    } else {
                      detectorWidget =
                          const Center(child: Text('Streaming, Looking for faces...'));
                    }

                    return detectorWidget;
                  },
                )
              ],
            );
          } else if (state is CameraErrorState) {
            return Center(child: Text(state.message));
          } else {
            // Camera is not initialized
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      /* floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<CameraBloc>().add(TakePicture());
          },
          child: const Icon(Icons.camera_alt),
        ), */
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}

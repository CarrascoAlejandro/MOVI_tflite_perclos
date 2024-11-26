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
                Expanded(child: CameraPreview(state.controller)),
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
                Expanded(child: CameraPreview(state.controller)),
                BlocBuilder<DetectorBloc, DetectorState>(
                  builder: (context, state) {
                    Widget detectorWidget = Container();
                    if (state is DetectorResultState) {
                      detectorWidget =
                          Center(child: Text("Model output: ${state.output}"));
                    } else if (state is DetectorErrorState) {
                      detectorWidget = Center(child: Text(state.message));
                    } else {
                      detectorWidget =
                          const Center(child: Text('Streaming...'));
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

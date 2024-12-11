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

class CameraShotScreen extends StatelessWidget {
  final CameraDescription camera;

  const CameraShotScreen({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    context.read<CameraBloc>().add(InitializeCameraEvent(camera));
    context.read<DetectorBloc>().add(InitializeModelEvent());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Take a Picture'),
      ),
      body: Center(
        child: BlocBuilder<CameraBloc, CameraState>(
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
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.teal,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      final image = await state.controller.takePicture();
                      context
                          .read<DetectorBloc>()
                          .add(PickImageDetectEvent(context, File(image.path)));
                    },
                    child: const Text('Take Picture', style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<DetectorBloc, DetectorState>(
                    builder: (context, state) {
                      if (state is DetectorResultState) {
                        return ResultsComponent(
                          value1: state.output.leftEyeOpenProbability,
                          value2: state.output.rightEyeOpenProbability,
                          value1label: 'Left Eye',
                          value2label: 'Right Eye',
                        );
                      } else if (state is DetectorErrorState) {
                        return Center(
                            child: ErrorComponent(errorMessage: state.message));
                      } else {
                        return const Text('Processing...');
                      }
                    },
                  ),
                ],
              );
            } else if (state is CameraErrorState) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_test_run/bloc/camera/camera_bloc.dart';
import 'package:flutter_camera_test_run/bloc/camera/camera_event.dart';
import 'package:flutter_camera_test_run/bloc/camera/camera_state.dart';

class StreamVideoScreen extends StatelessWidget {
  final CameraDescription camera;
  const StreamVideoScreen({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CameraBloc()..add(InitializeCameraEvent(camera)),
      child: Scaffold(
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
                      context.read<CameraBloc>().add(StartImageStreamEvent());
                    },
                    child: const Text('Start Image Stream'),
                  ),
                ],
              );
            } else if (state is CameraStreamingState) {
              return CameraPreview(state.controller);
            } else if (state is CameraErrorState) {
              return Center(child: Text(state.message));
            } else { // Camera is not initialized
              return const Center(child: Text('Initializing...'));
            }
          },
        ),
        /* floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<CameraBloc>().add(TakePicture());
          },
          child: const Icon(Icons.camera_alt),
        ), */
      ),
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

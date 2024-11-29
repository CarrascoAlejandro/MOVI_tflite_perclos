import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_test_run/bloc/camera/camera_bloc.dart';
import 'package:flutter_camera_test_run/bloc/detector/detector_bloc.dart';
import 'package:flutter_camera_test_run/bloc/image/image_bloc.dart';
import 'package:flutter_camera_test_run/widget/pick_image_screen.dart';
import 'package:flutter_camera_test_run/widget/stream_video_screen.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras[1];

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => CameraBloc()),
      BlocProvider(create: (context) => DetectorBloc()),
      BlocProvider(create: (context) => ImageBloc()),
    ],
    child: MaterialApp(
      theme: ThemeData.dark(),
      home: MyHomePage(camera: firstCamera),
    ),
  ));
}

class MyHomePage extends StatelessWidget {
  final CameraDescription camera;

  MyHomePage({required this.camera});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Stream Video'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StreamVideoScreen(camera: camera),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Pick Image'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PickImageScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Select an option from the drawer'),
      ),
    );
  }
}

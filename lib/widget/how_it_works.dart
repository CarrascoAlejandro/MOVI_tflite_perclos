import 'package:flutter/material.dart';

class HowItWorks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Face landmark detection is a computer vision technique that identifies key points on a human face, such as the eyes, nose, and mouth. '
          'These landmarks are used to analyze facial expressions and movements. '
          'In the context of calculating sleepiness, the detection focuses on the eyes and their behavior. '
          'By monitoring the frequency and duration of eye blinks, as well as the degree of eye closure, the system can estimate the level of sleepiness. '
          'Consistent patterns of prolonged eye closure and frequent blinking are indicators of drowsiness, which can be used to alert individuals to take necessary actions to stay awake and safe.',
          style: TextStyle(fontSize: 16.0),
        ),
      );
  }
}
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class FaceLandmarkPainter extends CustomPainter {
  Map<FaceLandmarkType, FaceLandmark?> landmarks;

  FaceLandmarkPainter({required this.landmarks});

  @override
  void paint(Canvas canvas, Size size) {
    print('ALECAR: Drawing ${landmarks.length} landmarks');

    // for debugging print the landmark map
    landmarks.forEach((key, value) {
      print('ALECAR: Landmark $key: ${value?.position.x}, ${value?.position.y}');
    });

    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    for (FaceLandmark? landmark in landmarks.values) {
      if (landmark != null) {
        final dx = landmark.position.x.toDouble();
        final dy = landmark.position.y.toDouble();
        if (dx.isFinite && dy.isFinite) {
          canvas.drawCircle(
            Offset(dx, dy),
            2.0,
            paint,
          );
        } else {
          print('ALECAR: Landmark position is not finite: $dx, $dy');
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
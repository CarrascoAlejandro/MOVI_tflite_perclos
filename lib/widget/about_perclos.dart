import 'package:flutter/material.dart';

class AboutPERCLOS extends StatelessWidget {
  const AboutPERCLOS({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What is PERCLOS?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'PERCLOS stands for "Percentage of Eye Closure." It\'s a metric that measures the proportion of time a driver\'s eyes are closed beyond a certain threshold (usually 80%) during a specific time period. This metric is primarily used to assess driver drowsiness and fatigue levels.',
          ),
          const SizedBox(height: 8),
          Image.asset('assets/hero_advanced_drowsiness.jpg'),
          const SizedBox(height: 16),
          const Text(
            'How is PERCLOS Used in Driver Drowsiness Detection?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '1. Eye-Tracking Systems:\n'
            '    * Cameras or specialized sensors are used to track the driver\'s eye movements.\n'
            '    * These systems analyze the video feed or sensor data to detect instances where the eyes are closed for extended periods.\n\n'
            '2. Machine Learning (ML) Models:\n'
            '    * ML models are trained on large datasets of eye images and videos from both alert and drowsy drivers.\n'
            '    * These models learn to recognize patterns associated with drowsiness, such as slow eyelid closure or micro-sleeps.\n'
            '    * By analyzing the driver\'s eye closure patterns in real-time, the ML model can estimate PERCLOS values.',
          ),
          const SizedBox(height: 16),
          Image.asset('assets/PERCLOS-system-operation-diagram-19.png'),
          const SizedBox(height: 8),
          const Text(
            'How PERCLOS Helps Prevent Accidents:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '* Early Detection: PERCLOS allows for early detection of drowsiness before it progresses to a dangerous level.\n'
            '* Real-time Alerts: When the PERCLOS value exceeds a predefined threshold, the system can trigger alerts to warn the driver.\n'
            '* Driver Assistance: Advanced systems can even take proactive measures, such as adjusting cabin temperature or playing stimulating sounds, to improve alertness.\n'
            '* Data-Driven Insights: By analyzing PERCLOS data, researchers and engineers can gain valuable insights into driver fatigue patterns, leading to improved vehicle design and safety features.',
          ),
        ],
      ),
    );
  }
}
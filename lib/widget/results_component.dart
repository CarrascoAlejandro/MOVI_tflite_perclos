import 'package:flutter/material.dart';

class ResultsComponent extends StatelessWidget {
  final double? value1;
  final double? value2;
  String? value1label = 'Value 1';
  String? value2label = 'Value 2';

  ResultsComponent({required this.value1, required this.value2, this.value1label, this.value2label});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Widget content;

    if (value1 == null || value2 == null) {
      backgroundColor = const Color.fromARGB(158, 183, 28, 28);
      content = Center(
        child: Text(
          'Error: One or both values are null',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      );
    } else if (value1! < 0.2 && value2! < 0.2) {
      backgroundColor = const Color.fromARGB(158, 183, 28, 28);
      content = _buildValuesContent();
    } else if (value1! < 0.2 || value2! < 0.2) {
      backgroundColor = const Color.fromARGB(167, 245, 127, 23);
      content = _buildValuesContent();
    } else {
      backgroundColor = const Color.fromARGB(193, 27, 94, 31);
      content = _buildValuesContent();
    }

    return Container(
      color: backgroundColor,
      child: content,
    );
  }

  Widget _buildValuesContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
        '$value1label: ${(value1! * 100).toStringAsFixed(2)}%',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
        '$value2label: ${(value2! * 100).toStringAsFixed(2)}%',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
        'User is probably ${value1! < 0.2 && value2! < 0.2 ? 'sleepy' : 'awake'}',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
      ),
    );
  }
}
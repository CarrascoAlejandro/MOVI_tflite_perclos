import 'package:flutter/material.dart';

class ErrorComponent extends StatelessWidget {
  final String errorMessage;

  const ErrorComponent({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48.0,
            ),
            SizedBox(height: 16.0),
            Text(
              errorMessage,
              style: TextStyle(
                color: Colors.red,
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
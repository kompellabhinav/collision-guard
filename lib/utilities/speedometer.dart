import 'package:flutter/material.dart';

class Speedometer extends StatelessWidget {
  final double speed;

  const Speedometer({required this.speed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      child: Card(
        elevation: 2.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Speed',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Container(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                strokeWidth: 10,
                value: speed / 100,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                backgroundColor: Colors.grey,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '$speed km/h',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

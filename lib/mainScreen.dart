import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<double>? _accelerometerValues;
  List<double>? _userAccelerometerValues;
  List<double>? _gyroscopeValues;

  final _streamSubScriptions =
      <StreamSubscription<dynamic>>[]; // Stream initialization

  @override
  Widget build(BuildContext context) {
    // Functions to reduce huge decimals to single decimal point
    final userAccerlerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();

    final accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();

    final gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sensor data"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text('User Accelerometer: $userAccerlerometer'),
          Text('Accelerometer: $accelerometer'),
          Text('Gyroscope: $gyroscope'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubScriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();

    _streamSubScriptions.add(
      userAccelerometerEvents.listen(
        (event) {
          setState(
            () {
              _userAccelerometerValues = <double>[event.x, event.y, event.z];
            },
          );
        },
      ),
    );

    _streamSubScriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(
            () {
              _accelerometerValues = <double>[event.x, event.y, event.z];
            },
          );
        },
      ),
    );

    _streamSubScriptions.add(
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          setState(
            () {
              _gyroscopeValues = <double>[event.x, event.y, event.z];
            },
          );
        },
      ),
    );
  }
}

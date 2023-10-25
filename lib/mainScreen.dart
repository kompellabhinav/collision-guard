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

  // Test Variables
  List<List<double>?> dataList = [];

  //Test Methods
  void addToDataList(List<double>? newData) {
    double prevValue = 0;
    List<double>? roundedData =
        newData!.map((e) => double.parse(e.toStringAsFixed(2))).toList();
    if (!dataList.contains(roundedData) && prevValue > roundedData[2]) {
      dataList.add(roundedData);
      prevValue = roundedData[2];
    }
  }

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
          ElevatedButton(
            onPressed: () {
              dispose();
              debugPrint(dataList.toString());
            },
            child: const Text("Stop"),
          )
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
              if (event.x != 0 || event.y != 0 || event.z != 0) {
                addToDataList(_userAccelerometerValues);
              }
              debugPrint(_streamSubScriptions[0].toString());
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

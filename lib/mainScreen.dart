import 'dart:async';

import 'package:collision_detection/dataScreen.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<double>? _accelerometerValues = [0.0, 0.0, 0.0];
  List<double>? _userAccelerometerValues = [0.0, 0.0, 0.0];
  List<double>? _gyroscopeValues = [0.0, 0.0, 0.0];

  final _streamSubScriptions =
      <StreamSubscription<dynamic>>[]; // Stream initialization

  // Test Variables
  List<List<double>> dataList = [
    [0.0, 0.0, 0.0]
  ];
  bool _streamActivity = false;

  //Test Methods
  void addToDataList(List<double>? newData) {
    List<double>? roundedData =
        newData!.map((e) => double.parse(e.toStringAsFixed(2))).toList();
    if (!dataList.contains(roundedData)) {
      dataList.add(roundedData);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      resumeStream();
                    });
                  },
                  child: const Text("Start")),
              ElevatedButton(
                onPressed: () {
                  pauseStream();
                  debugPrint(dataList.toString());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DataDisplay(dataList: dataList)));
                },
                child: const Text("Stop"),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void pauseStream() {
    for (final subscription in _streamSubScriptions) {
      subscription.pause();
    }
  }

  void resumeStream() {
    for (final subscription in _streamSubScriptions) {
      dataList = [];
      subscription.resume();
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

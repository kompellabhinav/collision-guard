import 'dart:async';

import 'package:collision_detection/data_collection.dart';
import 'package:collision_detection/data_screen.dart';
import 'package:collision_detection/gpsData.dart';
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

  final DataCollection collection = DataCollection();
  LocationData positionData = LocationData();

  List<dynamic> gpsData = [];
  double latitude = 0;
  double longitude = 0;
  double speed = 0;

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

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DataDisplay(dataList: dataList)));
                },
                child: const Text("Stop"),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
    DataCollection.getExternalDocumentPath();
    _streamSubScriptions.add(
      userAccelerometerEvents.listen(
        (event) {
          setState(
            () {
              _userAccelerometerValues = <double>[event.x, event.y, event.z];
              if (event.x != 0 || event.y != 0 || event.z != 0) {
                addToDataList(_userAccelerometerValues);
              }

              Future<void> updateGpsData() async {
                final gpsData = await positionData.getLocation();
                latitude = gpsData[0].latitude;
                longitude = gpsData[0].longitude;
                speed = gpsData[1] * 3.6; // convert to km/h
                debugPrint(gpsData.toString());
              }

              updateGpsData();

              _userAccelerometerValues = _userAccelerometerValues
                  ?.map((double v) => v * 3.6)
                  .toList(); // convert to km/h

              collection.saveData(
                "sensorData.txt",
                _userAccelerometerValues,
                latitude,
                longitude,
                speed,
              );
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

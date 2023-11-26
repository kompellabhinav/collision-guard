import 'dart:async';
import 'package:collision_detection/pages/accident.dart';
import 'package:telephony/telephony.dart';

import 'package:collision_detection/data_collection.dart';
import 'package:collision_detection/pages/data_screen.dart';
import 'package:collision_detection/gpsData.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Home extends StatefulWidget {
  final String title;

  const Home({Key? key, this.title = "Home"}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  List<double>? _userAccelerometerValues = [0.0, 0.0, 0.0];
  DateTime now = DateTime.now();

  final _streamSubScriptions =
      <StreamSubscription<dynamic>>[]; // Stream initialization

  // Test Variables
  List<List<double>> dataList = [
    [0.0, 0.0, 0.0]
  ];

  final Telephony telephony = Telephony.instance;
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sensor data"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text('User Accelerometer: $userAccerlerometer'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    resumeStream();
                  });
                },
                child: const Text(
                  "Start Graphing",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  pauseStream();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DataDisplay(dataList: dataList),
                    ),
                  );
                },
                child: const Text(
                  "Show Graph",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Accident()),
              );
            },
            child: const Text("Send Text"),
          )
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
    // DataCollection.getExternalDocumentPath();
    _streamSubScriptions.add(
      userAccelerometerEvents.listen(
        (event) {
          if (mounted) {
            setState(
              () {
                _userAccelerometerValues = <double>[event.x, event.y, event.z];
                if (event.x != 0 || event.y != 0 || event.z != 0) {
                  addToDataList(_userAccelerometerValues);
                }

                // Future<void> updateGpsData() async {
                //   final gpsData = await positionData.getLocation();
                //   latitude = gpsData[0].latitude;
                //   longitude = gpsData[0].longitude;
                //   speed = gpsData[1] * 3.6; // convert to km/h
                //   debugPrint(gpsData.toString());
                // }

                // updateGpsData();

                now = DateTime.now();

                _userAccelerometerValues = _userAccelerometerValues
                    ?.map((double v) => v * 3.6)
                    .toList(); // convert to km/h

                // collection.saveData(
                //   "sensorData.txt",
                //   _userAccelerometerValues,
                //   latitude,
                //   longitude,
                //   speed,
                //   now,
                // );
              },
            );
          }
        },
      ),
    );
    void askPermission() async {
      bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    }

    askPermission();
  }

  @override
  bool get wantKeepAlive => true;
}

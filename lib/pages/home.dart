import 'dart:async';
import 'package:collision_detection/pages/accident.dart';
import 'package:collision_detection/utilities/grid_item.dart';
import 'package:collision_detection/utilities/speedometer.dart';
import 'package:telephony/telephony.dart';

import 'package:collision_detection/data_collection.dart';
import 'package:collision_detection/pages/data_screen.dart';
import 'package:collision_detection/gpsData.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Home extends StatefulWidget {
  final String title;

  const Home({Key? key, this.title = "Collision Guard"}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  List<double>? _userAccelerometerValues = [0.0, 0.0, 0.0, 0.0];
  DateTime now = DateTime.now();

  final _streamSubScriptions =
      <StreamSubscription<dynamic>>[]; // Stream initialization
  bool streamStatus = false;

  // Test Variables
  List<List<double>> dataList = [
    [0.0, 0.0, 0.0, 0.0]
  ];
  String x = '0.0';
  String y = '0.0';
  String z = '0.0';

  final Telephony telephony = Telephony.instance;
  final DataCollection collection = DataCollection();
  LocationData positionData = LocationData();

  List<dynamic> gpsData = [];
  double latitude = 0;
  double longitude = 0;
  double speed = 0;

  //Test Methods
  void addToDataList(List<double>? newData, double speed) {
    newData!.add(speed);
    List<double>? roundedData =
        newData.map((e) => (double.parse(e.toStringAsFixed(2))) * 3.6).toList();
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          const Text(
            'Real-time Accelerometer values',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                GridItem(label: 'X', value: x),
                GridItem(label: 'Y', value: y),
                GridItem(label: 'Z', value: z),
              ],
            ),
          ),
          Speedometer(speed: speed),
          const SizedBox(
            height: 60,
          ),
          SizedBox(
            height: 50,
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  resumeStream();
                });
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue)),
              child: const Text(
                "Start Detection",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 60,
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                pauseStream();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataDisplay(dataList: dataList),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              child: const Text(
                "Show Driving Graph",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  void startStream() {
    streamStatus = true;
    _streamSubScriptions.add(
      userAccelerometerEvents.listen(
        (event) {
          if (mounted) {
            setState(
              () {
                Future<void> updateGpsData() async {
                  final gpsData = await positionData.getLocation();
                  latitude = gpsData[0].latitude;
                  longitude = gpsData[0].longitude;
                  speed = gpsData[1] * 3.6; // convert to km/h
                  speed = double.parse(speed.toStringAsFixed(2));
                }

                updateGpsData();

                _userAccelerometerValues = <double>[event.x, event.y, event.z];
                if (event.x != 0 || event.y != 0 || event.z != 0) {
                  addToDataList(_userAccelerometerValues, speed);
                }

                x = _userAccelerometerValues![0].toStringAsFixed(2);
                y = _userAccelerometerValues![1].toStringAsFixed(2);
                z = _userAccelerometerValues![2].toStringAsFixed(2);

                now = DateTime.now();

                _userAccelerometerValues = _userAccelerometerValues
                    ?.map((double v) => v * 3.6)
                    .toList(); // convert to km/h
                if (_userAccelerometerValues![2] < -30 ||
                    _userAccelerometerValues![2] > 30) {
                  pauseStream();
                  _userAccelerometerValues = [0.0, 0.0, 0, 0];
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Accident()),
                  );
                }
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
  }

  void pauseStream() {
    for (final subscription in _streamSubScriptions) {
      subscription.cancel();
    }
  }

  void resumeStream() {
    // if (!streamStatus) {
    startStream();
    // } else {
    //   for (final subscription in _streamSubScriptions) {
    //     dataList = [];
    //     subscription.resume();
    //   }
    // }
  }

  @override
  void initState() {
    super.initState();
    // DataCollection.getExternalDocumentPath();
    void askPermission() async {
      bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    }

    askPermission();
  }

  @override
  bool get wantKeepAlive => true;
}

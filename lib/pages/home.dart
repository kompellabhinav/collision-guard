import 'dart:async';

import 'package:collision_detection/data_collection.dart';
import 'package:collision_detection/gpsData.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Home extends StatefulWidget {
  final String title;

  const Home({Key? key, this.title = "Home"}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<double>? _accelerometerValues = [0.0, 0.0, 0.0];
  List<double>? _userAccelerometerValues = [0.0, 0.0, 0.0];
  List<double>? _gyroscopeValues = [0.0, 0.0, 0.0];
  // DateTime now = DateTime.now();

  final _streamSubScriptions =
      <StreamSubscription<dynamic>>[]; // Stream initialization

  // Test Variables
  List<List<double>> dataList = [
    [0.0, 0.0, 0.0]
  ];

  // final DataCollection collection = DataCollection();
  LocationData positionData = LocationData();

  List<dynamic> gpsData = [];
  double latitude = 0;
  double longitude = 0;
  double speed = 0;
  int secondsLeft = 30;
  late Timer timer;

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
                    // setState(() {
                    //   resumeStream();
                    // });
                  },
                  child: const Text("Start")),
              ElevatedButton(
                onPressed: () {
                  // pauseStream();
                  // dialogBox();
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

  // void dialogBox() {
  //   setState(() {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Seconds: $secondsLeft'),
  //           content: Text('Were you in an accident?'),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 _startTimer(true);
  //                 // Optionally perform any action when the user closes the dialog manually
  //               },
  //               child: Text('Close'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   });
  //   _startTimer(true);
  // }

  // void _startTimer(bool timerState) {
  //   if (timerState) {
  //     timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //       if (mounted) {
  //         if (secondsLeft > 0) {
  //           setState(() {
  //             secondsLeft--;
  //           });
  //         } else {
  //           timer.cancel();
  //           // Close the dialog or perform any other action when the timer expires
  //           Navigator.pop(context);
  //         }
  //       }
  //     });
  //   } else {
  //     timer.cancel();
  //   }
  // }

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

              _userAccelerometerValues = _userAccelerometerValues
                  ?.map((double v) => v * 3.6)
                  .toList(); // convert to km/h
            },
          );
          if (_userAccelerometerValues![2] < -5 ||
              _userAccelerometerValues![2] > 5) {
            // pauseStream();
            // dialogBox();
          }
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

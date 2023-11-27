import 'dart:async';
import 'dart:convert';

import 'package:collision_detection/gpsData.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

class Accident extends StatefulWidget {
  const Accident({super.key});

  @override
  State<Accident> createState() => _AccidentState();
}

class _AccidentState extends State<Accident> {
  int time = 15;
  late Timer countdown;
  double latitude = 0;
  double longitude = 0;
  LocationData positionData = LocationData();

  //Text message code
  String _message = "";
  final Telephony telephony = Telephony.instance;

  // Firebase Code
  late List<dynamic> contacts;
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref("contacts");

  @override
  void initState() {
    super.initState();
    retriveData();
    startTimer();
  }

  Future<void> updateGpsData() async {
    final gpsData = await positionData.getLocation();
    latitude = gpsData[0].latitude;
    longitude = gpsData[0].longitude;
    debugPrint("sendtext");
    sendText(latitude, longitude);
  }

  void startTimer() {
    debugPrint("Timer Start");
    countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (time > 0) {
        setState(() {
          time--;
          debugPrint(time.toString());
        });
      } else {
        // Timer reaches 0, perform any actions needed
        // For example, you might want to navigate to another screen
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NextScreen()));
        updateGpsData();
        countdown.cancel(); // Cancel the timer when done
        showEmergencyMessageDialog();
      }
    });
  }

  void stopTimer() {
    countdown.cancel();
    Future.delayed(const Duration(seconds: 2), () {
      // Go back to the previous page
      Navigator.pop(context);
    });
  }

  // SMS Functions

  Future<void> retriveData() async {
    contacts = [];
    DatabaseEvent data = await databaseReference.once();
    Object? strData = data.snapshot.value;
    if (strData != null) {
      String jsonEn = jsonEncode(strData);

      Map<String, dynamic> jsonDe = jsonDecode(jsonEn);
      Iterable<dynamic> vals = jsonDe.values;
      for (String val in vals) {
        String nam = val.split(";")[0];
        String num = val.split(";")[1];
        contacts.add([nam, num]);
      }
    }
    debugPrint(contacts.toString());
  }

  void sendText(double latitude, double longitude) {
    latitude = double.parse(latitude.toStringAsFixed(3));
    longitude = double.parse(longitude.toStringAsFixed(3));
    _message =
        "I am in an accident\nLatitude = $latitude\tLongitude = $longitude";
    debugPrint(_message.length.toString());
    for (int i = 0; i < contacts.length; i++) {
      String nums = contacts[i][1];
      telephony.sendSms(
        to: nums,
        message: _message,
      );
      debugPrint(nums);
    }
  }

  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks
    countdown.cancel();
    super.dispose();
  }

  void showEmergencyMessageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Emergency Message Sent'),
          content: const Text('Your emergency message has been sent.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accident?"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Center(
            child: Text(
              "Where you in an accident?",
              style: TextStyle(
                color: Colors.red,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                color: Colors.red,
              ),
              child: Center(
                child: Text(
                  time.toString(),
                  style: const TextStyle(
                      color: Color.fromARGB(255, 251, 234, 0),
                      fontSize: 120,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              height: 60,
              width: 180,
              child: ElevatedButton(
                onPressed: stopTimer,
                child: const Text(
                  "I am safe!",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

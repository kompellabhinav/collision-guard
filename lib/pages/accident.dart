import 'dart:async';
import 'dart:convert';

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

  //Text message code
  final String _message = "I am in an accident. Please help";
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

  void startTimer() {
    debugPrint("Timer Start");
    countdown = Timer.periodic(Duration(seconds: 1), (timer) {
      if (time > 0) {
        setState(() {
          time--;
          debugPrint(time.toString());
        });
      } else {
        // Timer reaches 0, perform any actions needed
        // For example, you might want to navigate to another screen
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NextScreen()));
        sendText();
        countdown.cancel(); // Cancel the timer when done
      }
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

  void sendText() {
    for (int i = 0; i < contacts.length; i++) {
      String nums = contacts[i][1];
      telephony.sendSms(to: nums, message: _message);
    }
  }

  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks
    countdown.cancel();
    super.dispose();
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
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _secondsLeft = 15;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimerDelayed();
  }

  void _startTimerDelayed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Timer Dialog'),
          content: Text('This dialog will close in $_secondsLeft seconds.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Optionally perform any action when the user closes the dialog manually
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _timer.cancel();
        // Close the dialog or perform any other action when the timer expires
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Timer Dialog'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Dialog will be shown after 5 seconds
          },
          child: Text('Show Dialog after 5 seconds'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

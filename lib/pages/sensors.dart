import 'package:flutter/material.dart';

class Sensor extends StatefulWidget {
  final String title;

  const Sensor({Key? key, this.title = "Sensors"}) : super(key: key);

  @override
  State<Sensor> createState() => _SensorState();
}

class _SensorState extends State<Sensor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Sensors Page"),
    );
  }
}

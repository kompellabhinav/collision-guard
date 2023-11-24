import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final String title;

  const Settings({Key? key, this.title = "Settings"}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Settings Page"),
    );
  }
}

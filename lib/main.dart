import 'package:collision_detection/tabs.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          brightness: Brightness.dark,
          primary: Colors.black,
          secondary: Colors.blue,
        ),
      ),
      home: Scaffold(
        body: TabsController(),
      ),
    );
  }
}

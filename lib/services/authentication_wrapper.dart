import 'package:collision_detection/tabs.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:collision_detection/pages/login.dart';
import 'package:collision_detection/pages/home.dart';

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasData) {
            debugPrint("Home");
            return const TabsController();
          } else {
            debugPrint("Login");
            return Login();
          }
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(
      BuildContext context, String email, String password) async {
    print("sign in");
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _auth.currentUser;
    } catch (e) {
      print(e);
      _showErrorDialog(
          context, "Sign Up Error", "Wrong email or password!\nTry Again!");
      return null;
    }
  }

  Future<User?> signUp(
      BuildContext context, String email, String password) async {
    print("sign in");
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _auth.currentUser;
    } catch (e) {
      print(e);
      _showErrorDialog(context, "Sign In Error", e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

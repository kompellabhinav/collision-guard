import 'package:collision_detection/pages/contacts.dart';
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
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      height: 150,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 28, 28, 30),
          borderRadius: BorderRadius.circular(18),
        ),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Contacts"),
              trailing: Icon(Icons.keyboard_arrow_right_sharp),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Contacts(),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

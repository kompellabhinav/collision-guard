import 'dart:convert';

import 'package:collision_detection/utilities/contacts_util.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  late List<dynamic> contact;
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref("contacts");

  final TextEditingController _name = TextEditingController();
  final TextEditingController _number = TextEditingController();

  @override
  void initState() {
    retriveData();
    setState(() {});
    super.initState();
  }

  void addContact(String name, String number) {
    contact.add([name, number]);
    debugPrint("Add");
    String data = "$name;$number";
    databaseReference.push().set(data);
    setState(() {});
  }

  Future<void> retriveData() async {
    contact = [];
    DatabaseEvent data = await databaseReference.once();
    Object? strData = data.snapshot.value;
    if (strData != null) {
      String jsonEn = jsonEncode(strData);

      Map<String, dynamic> jsonDe = jsonDecode(jsonEn);
      Iterable<dynamic> vals = jsonDe.values;
      for (String val in vals) {
        String nam = val.split(";")[0];
        String num = val.split(";")[1];
        contact.add([nam, num]);
      }
    }
    setState(() {});
  }

  Future<void> deleteContact(String name, String number) async {
    debugPrint("Delete");
    String fireName = "$name;$number";
    String deleteKey = '';
    DatabaseEvent data = await databaseReference.once();
    Object? strData = data.snapshot.value;
    String jsonEn = jsonEncode(strData);
    Map<String, dynamic> jsonDe = jsonDecode(jsonEn);
    for (final String key in jsonDe.keys) {
      if (jsonDe[key] == fireName) {
        deleteKey = key;
      }
    }
    if (deleteKey != '') {
      debugPrint('$deleteKey');
      await databaseReference.child(deleteKey).remove();
      retriveData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: contact.length,
              itemBuilder: (context, index) {
                return ContactTile(
                  name: contact[index][0],
                  number: contact[index][1],
                  deleteFunction: (context) =>
                      deleteContact(contact[index][0], contact[index][1]),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _name,
                  decoration: const InputDecoration(
                    labelText: "Enter name",
                    fillColor: Colors.grey, // Change the background color
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: _number,
                  decoration: const InputDecoration(
                    labelText: "Enter name",
                    fillColor: Colors.grey, // Change the background color
                    filled: true,
                  ),
                ),
              ),
              Container(
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    addContact(_name.text, _number.text);
                    print(_name.text);
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

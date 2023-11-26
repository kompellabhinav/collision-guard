import 'package:collision_detection/utilities/contacts_util.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<dynamic> contact = [
    ["Abhinav", "9949379007"]
  ];
  final TextEditingController _name = TextEditingController();
  final TextEditingController _number = TextEditingController();

  void addContact(String name, String number) {
    contact.add([name, number]);
    setState(() {});
  }

  void deleteContact(int index) {
    contact.removeAt(index);
    setState(() {});
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
                  deleteFunction: (context) => deleteContact(index),
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

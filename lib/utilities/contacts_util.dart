import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ContactTile extends StatelessWidget {
  final String name;
  final String number;
  Function(BuildContext)? deleteFunction;
  ContactTile({
    super.key,
    required this.name,
    required this.number,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 15),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        child: Container(
          height: 60,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 28, 28, 30),
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                name,
                style: const TextStyle(fontSize: 21),
              ),
              Text(
                number,
                style: const TextStyle(fontSize: 21),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

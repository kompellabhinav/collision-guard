import 'package:flutter/material.dart';

class DataScreen extends StatelessWidget {
  final List<double>? data;

  DataScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Card(
        child: Text(data.toString()),
      ),
    );
  }
}

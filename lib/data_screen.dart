import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DataDisplay extends StatelessWidget {
  final List<List<double>> dataList;
  const DataDisplay({super.key, required this.dataList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph Data'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  bottom: BorderSide(
                    color: Color(0xff37434d),
                    width: 1,
                  ),
                  left: BorderSide(
                    color: Colors.transparent,
                  ),
                  right: BorderSide(
                    color: Colors.transparent,
                  ),
                  top: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
              // minX: 0,
              // maxX: dataList.length.toDouble(),
              // minY: -10, // Set the Y-axis minimum and maximum values as needed.
              // maxY: 10,
              lineBarsData: [
                LineChartBarData(
                  spots: dataList.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value[2]);
                  }).toList(),
                  isCurved: true,
                  color: const Color(0xff4af699),
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

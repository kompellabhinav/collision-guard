import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DataDisplay extends StatelessWidget {
  final List<List<double>> dataList;
  const DataDisplay({super.key, required this.dataList});

  void printData() {
    debugPrint(dataList.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph Data'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                      lineBarsData: [
                        LineChartBarData(
                          spots: dataList.asMap().entries.map((entry) {
                            return FlSpot(entry.key.toDouble(), entry.value[0]);
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
              const Center(
                child: Text(
                  "X axis",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.amber,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                      lineBarsData: [
                        LineChartBarData(
                          spots: dataList.asMap().entries.map((entry) {
                            return FlSpot(entry.key.toDouble(), entry.value[1]);
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
              const Center(
                child: Text(
                  "Y axis",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.amber,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
              const Center(
                child: Text(
                  "Z values",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.amber,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                      lineBarsData: [
                        LineChartBarData(
                          spots: dataList.asMap().entries.map((entry) {
                            return FlSpot(entry.key.toDouble(), entry.value[3]);
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
              const Center(
                child: Text(
                  "Speed",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.amber,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: printData,
                  child: const Text(
                    "Export data",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

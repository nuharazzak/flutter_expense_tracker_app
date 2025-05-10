import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  Map<String, double> categoryData = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('expenses')
        .orderBy('date', descending: true)
        .get();

    Map<String, double> data = {};

    for (var doc in snapshot.docs) {
      Map<String, dynamic> expense = doc.data() as Map<String, dynamic>;
      String category = expense['category'];
      double amount = expense['amount'].toDouble();

      if (data.containsKey(category)) {
        data[category] = data[category]! + amount;
      } else {
        data[category] = amount;
      }
    }

    setState(() {
      categoryData = data;
    });
  }

  Color getColorForCategory(String category) {
    switch (category) {
      case 'Food':
        return const Color.fromARGB(255, 19, 212, 8);
      case 'Rent':
        return const Color.fromARGB(255, 232, 9, 9);
      case 'Transportation':
        return Colors.blue;
      case 'Entertainment':
        return const Color.fromARGB(255, 6, 125, 10);
      case 'Education':
        return const Color.fromARGB(255, 231, 149, 9);
      case 'Monthly Shopping':
        return Colors.yellow;
      case 'medicine':
        return const Color.fromARGB(255, 90, 5, 114);
      case 'Other':
        return const Color.fromARGB(255, 243, 33, 184);
      default:
        return const Color.fromARGB(255, 59, 19, 187);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: categoryData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Pie Chart
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: PieChart(
                      PieChartData(
                        sections: categoryData.entries.map(
                          (entry) {
                            return PieChartSectionData(
                              title: '', // Hide labels inside the chart
                              value: entry.value,
                              color: getColorForCategory(entry.key),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                ),
                // Custom Legend
                Wrap(
                  spacing: 8.0, // Space between items horizontally
                  runSpacing: 8.0, // Space between items vertically
                  children: categoryData.entries.map((entry) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          color: getColorForCategory(entry.key), // Square color
                        ),
                        const SizedBox(width: 8),
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
    );
  }
}

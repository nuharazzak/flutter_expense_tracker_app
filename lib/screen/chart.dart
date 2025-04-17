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
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: categoryData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: PieChart(
                PieChartData(
                  sections: categoryData.entries.map(
                    (entry) {
                      return PieChartSectionData(
                        title: entry.key,
                        value: entry.value,
                        color: getColorForCategory(entry.key),
                        titleStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
    );
  }
}

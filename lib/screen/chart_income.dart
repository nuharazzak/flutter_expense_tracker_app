import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChartIncome extends StatefulWidget {
  const ChartIncome({super.key, required this.selectedMonth});
  final DateTime selectedMonth;

  @override
  State<ChartIncome> createState() => _ChartIncomeState();
}

class _ChartIncomeState extends State<ChartIncome> {
  Map<String, double> categoryData = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final start =
        DateTime(widget.selectedMonth.year, widget.selectedMonth.month, 1);
    final end =
        DateTime(widget.selectedMonth.year, widget.selectedMonth.month + 1, 1);
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('incomes')
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThan: end)
        // .collection('incomes')
        // .orderBy('date', descending: true)
        .get();

    Map<String, double> data = {};

    for (var doc in snapshot.docs) {
      Map<String, dynamic> income = doc.data() as Map<String, dynamic>;
      String category = income['category'];
      double amount = income['amount'].toDouble();

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
      case 'Salary':
        return Colors.green;
      case 'Business':
        return Colors.blue;
      case 'Investments':
        return Colors.orange;
      case 'Freelancing':
        return Colors.purple;
      case 'Other':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: categoryData.isEmpty
          ? Center(
              child: Text("No data available...."),
            )
          : Column(
              children: [
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
                ),
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
                            color: Colors.white,
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

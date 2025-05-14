import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartExpense extends StatefulWidget {
  const ChartExpense({super.key});

  @override
  State<ChartExpense> createState() => _ChartExpenseState();
}

class _ChartExpenseState extends State<ChartExpense> {
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
      case 'Utilities':
        return Colors.orange;
      case 'Groceries':
        return Colors.green;
      case 'Health and Fitness':
        return Colors.teal;
      case 'Personal Care':
        return Colors.pink;
      case 'Insurance':
        return Colors.indigo;
      case 'Savings and Investments':
        return Colors.cyan;
      case 'Debt Payments':
        return Colors.brown;
      case 'Subscriptions':
        return Colors.lime;
      case 'Travel':
        return Colors.amber;
      case 'Gifts and Donations':
        return Colors.purple;
      case 'Miscellaneous':
        return Colors.grey;

      case 'Home Improvement':
        return Colors.blueGrey;
      case 'pets':
        return Colors.brown;
      case 'medicine':
        return const Color.fromARGB(255, 90, 5, 114);

      default:
        return const Color.fromARGB(255, 59, 19, 187);
    }
  }

  @override
  // Widget build(BuildContext context) {
  //   // Sort the categoryData by value (amount) in descending order and take the top 7
  //   final topCategories = categoryData.entries.toList()
  //     ..sort((a, b) => b.value.compareTo(a.value)); // Sort by amount
  //   final limitedCategories = topCategories.take(7).toList(); // Take top 7

  //   return Padding(
  //     padding: const EdgeInsets.all(4),
  //     child: categoryData.isEmpty
  //         ? const Center(child: CircularProgressIndicator())
  //         : Column(
  //             children: [
  //               // Pie Chart
  //               Expanded(
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(16.0),
  //                   child: PieChart(
  //                     PieChartData(
  //                       sections: limitedCategories.map(
  //                         (entry) {
  //                           return PieChartSectionData(
  //                             title: '', // Hide labels inside the chart
  //                             value: entry.value,
  //                             color: getColorForCategory(entry.key),
  //                           );
  //                         },
  //                       ).toList(),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               // Custom Legend
  //               Wrap(
  //                 spacing: 8.0, // Space between items horizontally
  //                 runSpacing: 8.0, // Space between items vertically
  //                 children: limitedCategories.map((entry) {
  //                   return Row(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Container(
  //                         width: 16,
  //                         height: 16,
  //                         color: getColorForCategory(entry.key), // Square color
  //                       ),
  //                       const SizedBox(width: 8),
  //                       Text(
  //                         entry.key,
  //                         style: const TextStyle(
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                     ],
  //                   );
  //                 }).toList(),
  //               ),
  //             ],
  //           ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    final topCategories = categoryData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // Sort by amount
    final limitedCategories = topCategories.take(7).toList(); // Take top 7
    return Padding(
      padding: EdgeInsets.all(4),
      child: categoryData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: PieChart(
                      PieChartData(
                        sections: limitedCategories.map(
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
                  children: limitedCategories.map((entry) {
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
                            color: Colors.white,
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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expense_tracker_app/provider/currency_provider.dart';

class SummaryScreen extends ConsumerStatefulWidget {
  const SummaryScreen({
    super.key,
    required this.selectedMonth,
    required this.onMonthChanged,
  });

  final DateTime selectedMonth;
  final ValueChanged<DateTime> onMonthChanged;

  @override
  ConsumerState<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends ConsumerState<SummaryScreen> {
  DateTime _selectedMonth = DateTime.now();

  void _pickMonth(BuildContext context) async {
    final picked = await showMonthPicker(
      context: context,
      initialDate: widget.selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        //_selectedMonth = DateTime(picked.year, picked.month);
        widget.onMonthChanged(DateTime(picked.year, picked.month));
      });
    }
  }

  Future<double> _getTotalForMonth(
      String collectionName, DateTime month) async {
    double total = 0.0;
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .where('date', isGreaterThanOrEqualTo: start)
          .where('date', isLessThan: end)
          .get();

      for (var doc in snapshot.docs) {
        total += (doc['amount'] as num).toDouble();
      }
    } catch (e) {
      print("Error fetching $collectionName: $e");
    }

    return total;
  }

// Removed unused variables and widgets referencing undefined allIncomes and allExpenses.

  Future<double> _getTotal(String collectionName) async {
    double total = 0.0;

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection(collectionName).get();

      for (var doc in snapshot.docs) {
        total += (doc['amount'] as num).toDouble();
      }
    } catch (e) {
      print("Error fetching $collectionName: $e");
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Summary',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month),
            onPressed: () => _pickMonth(context),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: FutureBuilder(
        future: Future.wait([
          _getTotalForMonth('incomes', widget.selectedMonth),
          _getTotalForMonth('expenses', widget.selectedMonth),
        ]),
        // FutureBuilder(
        //   future: Future.wait([
        //     _getTotal('incomes'),
        //     _getTotal('expenses'),
        //   ]),
        builder: (context, AsyncSnapshot<List<double>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load data'),
            );
          }
          if (snapshot.hasData) {
            double totalIncome = snapshot.data![0];
            double totalExpense = snapshot.data![1];
            double netBalance = totalIncome - totalExpense;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      'Total Income:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                    ),
                    trailing: Text(
                      '$currency ${totalIncome.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 74, 3, 56),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    title: Text(
                      'Total Expense:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                    ),
                    trailing: Text(
                      '$currency ${totalExpense.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 74, 3, 56)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(
                    color: Colors.grey,
                    thickness: 1.5,
                  ),
                  ListTile(
                    title: Text(
                      'Net Balance:',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Color.fromARGB(255, 9, 95, 12)),
                    ),
                    trailing: Text(
                      '$currency ${netBalance.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: netBalance >= 0
                            ? Color.fromARGB(255, 9, 95, 12)
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('No data available'),
          );
        },
      ),
    );
  }
}

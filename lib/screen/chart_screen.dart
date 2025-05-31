import 'package:flutter/material.dart';

import 'package:my_expense_tracker_app/screen/chart_expense.dart';
import 'package:my_expense_tracker_app/screen/chart_income.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key, required this.selectedMonth});

  final DateTime selectedMonth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      appBar: AppBar(
        title: Text(
          "Chart",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Income Chart Section
            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 143, 123, 145),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Income Chart",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 25,
                        ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: ChartIncome(
                      selectedMonth: selectedMonth,
                    ), // Replace with your income chart widget
                  ),
                ],
              ),
            ),
            // Expenses Chart Section
            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 143, 123, 145),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Expenses Chart",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 25,
                        ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: ChartExpense(
                      selectedMonth: selectedMonth,
                    ), // Replace with your expenses chart widget
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

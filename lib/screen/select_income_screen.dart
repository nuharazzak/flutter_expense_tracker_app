import 'package:flutter/material.dart';

import 'package:my_expense_tracker_app/screen/add_income.dart';
import 'package:my_expense_tracker_app/screen/view_income_screen.dart';

class SelectIncomeScreen extends StatelessWidget {
  SelectIncomeScreen({super.key});

  final List<Map<String, dynamic>> incomes = [
    {
      'name': 'Salary',
      'icon': Icons.attach_money,
      'color': const Color.fromARGB(255, 19, 212, 8)
    },
    {
      'name': 'Business',
      'icon': Icons.business,
      'color': const Color.fromARGB(255, 232, 9, 9),
    },
    {
      'name': 'Investments',
      'icon': Icons.trending_up,
      'color': Colors.blue,
    },
    {
      'name': 'Other',
      'icon': Icons.abc,
      'color': const Color.fromARGB(255, 125, 6, 95),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Income'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of items per row
            crossAxisSpacing: 8.0, // Horizontal spacing between items
            mainAxisSpacing: 8.0, // Vertical spacing between items
            childAspectRatio: 2, // Width-to-height ratio of each item
          ),
          itemCount: incomes.length,
          itemBuilder: (context, index) {
            final income = incomes[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddIncome(
                      income: income,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: income['color']
                      .withOpacity(0.2), // Light background color
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: income['color'], // Border color
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      income['icon'],
                      color: income['color'],
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      income['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow:
                          TextOverflow.ellipsis, // Truncate text with ellipsis
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ViewIncomeScreen(),
              ));
        },
        label: Text('View All Incomes'),
        icon: Icon(Icons.list),
      ),
    );
  }
}

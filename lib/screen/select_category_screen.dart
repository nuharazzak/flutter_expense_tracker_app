import 'package:flutter/material.dart';
import 'package:my_expense_tracker_app/screen/add_expense.dart';
import 'dart:async';

class SelectCategoryScreen extends StatefulWidget {
  SelectCategoryScreen({super.key});

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Food',
      'icon': Icons.fastfood,
      'color': const Color.fromARGB(255, 19, 212, 8)
    },
    {
      'name': 'Rent',
      'icon': Icons.home,
      'color': const Color.fromARGB(255, 232, 9, 9)
    },
    {
      'name': 'Transportation',
      'icon': Icons.directions_car,
      'color': Colors.blue
    },
    {
      'name': 'Entertainment',
      'icon': Icons.movie,
      'color': const Color.fromARGB(255, 6, 125, 10)
    },
    {
      'name': 'Education',
      'icon': Icons.school,
      'color': const Color.fromARGB(255, 231, 149, 9)
    },
    {
      'name': 'Monthly Shopping',
      'icon': Icons.shopping_cart,
      'color': Colors.yellow
    },
    {
      'name': 'Medicine',
      'icon': Icons.medical_services,
      'color': const Color.fromARGB(255, 90, 5, 114)
    },
    {'name': 'Utilities', 'icon': Icons.lightbulb, 'color': Colors.orange},
    {
      'name': 'Groceries',
      'icon': Icons.local_grocery_store,
      'color': Colors.green
    },
    {
      'name': 'Health and Fitness',
      'icon': Icons.fitness_center,
      'color': Colors.teal
    },
    {'name': 'Personal Care', 'icon': Icons.spa, 'color': Colors.pink},
    {'name': 'Insurance', 'icon': Icons.shield, 'color': Colors.indigo},
    {
      'name': 'Savings and Investments',
      'icon': Icons.savings,
      'color': Colors.cyan
    },
    {'name': 'Debt Payments', 'icon': Icons.credit_card, 'color': Colors.brown},
    {
      'name': 'Subscriptions',
      'icon': Icons.subscriptions,
      'color': Colors.lime
    },
    {
      'name': 'Gifts and Donations',
      'icon': Icons.card_giftcard,
      'color': Colors.purple
    },
    {'name': 'Travel', 'icon': Icons.travel_explore, 'color': Colors.amber},
    {'name': 'Miscellaneous', 'icon': Icons.category, 'color': Colors.grey},
    {'name': 'Business', 'icon': Icons.business, 'color': Colors.deepOrange},
    {
      'name': 'Charity',
      'icon': Icons.volunteer_activism,
      'color': Colors.lightGreen
    },
    {'name': 'Pets', 'icon': Icons.pets, 'color': Colors.brown},
    {'name': 'Home Improvement', 'icon': Icons.build, 'color': Colors.blueGrey},
  ];

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isLandscape ? 4 : 2, // Number of items per row
            crossAxisSpacing: 8.0, // Horizontal spacing between items
            mainAxisSpacing: 8.0, // Vertical spacing between items
            childAspectRatio:
                isLandscape ? 1.5 : 2, // Width-to-height ratio of each item
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final start = index * 0.05;
                final end = start + 0.5;
                final animationValue = CurvedAnimation(
                  parent: _controller,
                  curve: Interval(
                    start.clamp(0.0, 1.0),
                    end.clamp(0.0, 1.0),
                    curve: Curves.easeOut,
                  ),
                ).value;
                return Opacity(
                  opacity: animationValue,
                  child: Transform.scale(
                    scale: 0.8 + 0.2 * animationValue,
                    child: child,
                  ),
                );
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddExpense(category: category),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: category['color']
                        .withOpacity(0.2), // Light background color
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: category['color'], // Border color
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: category['name'],
                        child: Icon(
                          category['icon'],
                          color: category['color'],
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow
                            .ellipsis, // Truncate text with ellipsis
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

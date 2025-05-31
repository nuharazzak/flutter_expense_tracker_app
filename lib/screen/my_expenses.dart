import 'package:flutter/material.dart';
import 'package:my_expense_tracker_app/model/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_expense_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expense_tracker_app/provider/currency_provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MyExpenses extends ConsumerStatefulWidget {
  const MyExpenses({super.key, required this.selectedMonth});

  final DateTime selectedMonth;

  @override
  ConsumerState<MyExpenses> createState() => _MyExpensesState();
}

class _MyExpensesState extends ConsumerState<MyExpenses> {
  Stream<QuerySnapshot> _getExpenses() {
    final start =
        DateTime(widget.selectedMonth.year, widget.selectedMonth.month, 1);
    final end =
        DateTime(widget.selectedMonth.year, widget.selectedMonth.month + 1, 1);
    return FirebaseFirestore.instance
        // .collection('expenses')
        // .orderBy('date', descending: true)
        // .snapshots();
        .collection('expenses')
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThan: end)
        .orderBy('date', descending: true)
        .snapshots();
  }

  Map<String, dynamic> getCategoryDetails(String category) {
    switch (category) {
      case 'Food':
        return {
          'color': const Color.fromARGB(255, 19, 212, 8),
          'icon': const Icon(Icons.fastfood, color: Colors.white),
        };
      case 'Rent':
        return {
          'color': const Color.fromARGB(255, 232, 9, 9),
          'icon': const Icon(Icons.home, color: Colors.white),
        };
      case 'Transportation':
        return {
          'color': Colors.blue,
          'icon': const Icon(Icons.directions_car, color: Colors.white),
        };
      case 'Entertainment':
        return {
          'color': const Color.fromARGB(255, 6, 125, 10),
          'icon': const Icon(Icons.movie, color: Colors.white),
        };
      case 'Education':
        return {
          'color': const Color.fromARGB(255, 231, 149, 9),
          'icon': const Icon(Icons.school, color: Colors.white),
        };
      case 'Monthly Shopping':
        return {
          'color': Colors.yellow,
          'icon': const Icon(Icons.shopping_cart, color: Colors.white),
        };
      case 'Medicine':
        return {
          'color': const Color.fromARGB(255, 90, 5, 114),
          'icon': const Icon(Icons.medical_services, color: Colors.white),
        };
      case 'Utilities':
        return {
          'color': Colors.orange,
          'icon': const Icon(Icons.lightbulb, color: Colors.white),
        };
      case 'Groceries':
        return {
          'color': Colors.green,
          'icon': const Icon(Icons.local_grocery_store, color: Colors.white),
        };
      case 'Health and Fitness':
        return {
          'color': Colors.teal,
          'icon': const Icon(Icons.fitness_center, color: Colors.white),
        };
      case 'Personal Care':
        return {
          'color': Colors.pink,
          'icon': const Icon(Icons.spa, color: Colors.white),
        };
      case 'Servings and Investments':
        return {
          'color': Colors.cyan,
          'icon': const Icon(Icons.savings, color: Colors.white),
        };
      case 'Debt Payments':
        return {
          'color': Colors.brown,
          'icon': const Icon(Icons.credit_card, color: Colors.white),
        };
      case 'Subscriptions':
        return {
          'color': Colors.lime,
          'icon': const Icon(Icons.subscriptions, color: Colors.white),
        };
      case 'Gifts and Donations':
        return {
          'color': const Color.fromARGB(141, 30, 155, 174),
          'icon': const Icon(Icons.card_giftcard, color: Colors.white),
        };
      case 'Travel':
        return {
          'color': const Color.fromARGB(255, 243, 33, 184),
          'icon': const Icon(Icons.airplanemode_active, color: Colors.white),
        };
      case 'Charity':
        return {
          'color': const Color.fromARGB(255, 243, 33, 184),
          'icon': const Icon(Icons.volunteer_activism, color: Colors.white),
        };
      case 'Pets':
        return {
          'color': Colors.brown,
          'icon': const Icon(Icons.pets, color: Colors.white),
        };
      case 'Home Improvement':
        return {
          'color': Colors.blueGrey,
          'icon': const Icon(Icons.build, color: Colors.white),
        };

      case 'Miscellaneous':
        return {
          'color': Colors.grey,
          'icon': const Icon(Icons.category, color: Colors.white),
        };

      default:
        return {
          'color': const Color.fromARGB(117, 158, 158, 158),
          'icon': const Icon(Icons.category, color: Colors.white),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      appBar: AppBar(
        title: Text(
          "My Expenses",
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _getExpenses(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                print('It is working');
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No data found...'),
                );
              } else {
                final expense = snapshot.data!.docs;
                return Expanded(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      itemCount: expense.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 400),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Dismissible(
                                key: Key(expense[index].id),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) async {
                                  await FirebaseFirestore.instance
                                      .collection('expenses')
                                      .doc(expense[index].id)
                                      .delete();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Expense deleted')),
                                  );
                                },
                                child: Card(
                                  //shadowColor: Colors.blueGrey,
                                  // color: const Color.fromARGB(255, 239, 134, 213),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color.fromARGB(
                                              255, 141, 3, 132),
                                          const Color.fromARGB(
                                              255, 235, 35, 145),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(),
                                          offset: Offset(0, 2),
                                          blurRadius: 5.0,
                                          spreadRadius: -1.0,
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      leading: CircleAvatar(
                                        backgroundColor: getCategoryDetails(
                                            expense[index]
                                                ['category'])['color'],
                                        child: getCategoryDetails(
                                            expense[index]['category'])['icon'],
                                      ),
                                      title: Text(
                                        expense[index]['title'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      trailing: Text(
                                        '$currency ${expense[index]['amount'].toString()}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      onTap: () {
                                        // Navigate to EditExpenseScreen
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditExpenseScreen(
                                              expense: Expense(
                                                id: expense[index].id,
                                                title: expense[index]['title'],
                                                amount: expense[index]
                                                    ['amount'],
                                                category: expense[index]
                                                    ['category'],
                                                date: (expense[index]['date']
                                                        as Timestamp)
                                                    .toDate(),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

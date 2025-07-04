import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:my_expense_tracker_app/model/income.dart';
import 'package:my_expense_tracker_app/screen/edit_income_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expense_tracker_app/provider/currency_provider.dart';

class ViewIncomeScreen extends ConsumerStatefulWidget {
  const ViewIncomeScreen({required this.selectedMonth, super.key});

  final DateTime selectedMonth;

  @override
  ConsumerState<ViewIncomeScreen> createState() => _ViewIncomeScreenState();
}

class _ViewIncomeScreenState extends ConsumerState<ViewIncomeScreen> {
  Stream<QuerySnapshot> _getIncomes() {
    final start =
        DateTime(widget.selectedMonth.year, widget.selectedMonth.month, 1);
    final end =
        DateTime(widget.selectedMonth.year, widget.selectedMonth.month + 1, 1);
    return FirebaseFirestore.instance
        .collection('incomes')
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThan: end)
        .orderBy('date', descending: true)
        .snapshots();
    // return FirebaseFirestore.instance
    //     .collection('incomes')
    //     .orderBy('date', descending: true)
    //     .snapshots();
  }

  Map<String, dynamic> getIncomeDetails(String category) {
    switch (category) {
      case 'Salary':
        return {
          'name': 'Salary',
          'color': const Color.fromARGB(255, 19, 212, 8),
          'icon': const Icon(
            Icons.attach_money,
            color: Colors.white,
          )
        };
      case 'Business':
        return {
          'name': 'Business',
          'color': const Color.fromARGB(255, 232, 9, 9),
          'icon': const Icon(
            Icons.business,
            color: Colors.white,
          )
        };
      case 'Investments':
        return {
          'name': 'Investments',
          'color': Colors.blue,
          'icon': const Icon(
            Icons.trending_up,
            color: Colors.white,
          )
        };
      case 'Other':
        return {
          'name': 'Other',
          'color': const Color.fromARGB(255, 235, 10, 213),
          'icon': const Icon(
            Icons.abc,
            color: Colors.white,
          )
        };
      default:
        return {
          'name': 'Other',
          'color': const Color.fromARGB(255, 6, 125, 10),
          'icon': const Icon(
            Icons.abc,
            color: Colors.white,
          )
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
          'My Incomes',
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _getIncomes(),
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
                final income = snapshot.data!.docs;
                return Expanded(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      itemCount: income.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 400),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Dismissible(
                                key: Key(income[index].id),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) async {
                                  await FirebaseFirestore.instance
                                      .collection('incomes')
                                      .doc(income[index].id)
                                      .delete();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Income deleted successfully')),
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
                                          color: Colors.black.withOpacity(0.2),
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
                                        backgroundColor: getIncomeDetails(
                                            income[index]['category'])['color'],
                                        child: getIncomeDetails(
                                            income[index]['category'])['icon'],
                                      ),
                                      title: Text(
                                        income[index]['title'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      trailing: Text(
                                        '$currency ${income[index]['amount'].toString()}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      onTap: () {
                                        // Navigate to the EditIncomeScreen
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditIncomeScreen(
                                              income: Income(
                                                id: income[index].id,
                                                title: income[index]['title'],
                                                amount: income[index]['amount'],
                                                category: income[index]
                                                    ['category'],
                                                date: (income[index]['date']
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

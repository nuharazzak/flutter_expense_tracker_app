import 'package:flutter/material.dart';
import 'package:my_expense_tracker_app/screen/add_expense.dart';
import 'package:my_expense_tracker_app/model/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_expense_tracker_app/screen/chart.dart';
import 'edit_expense_screen.dart';

class MyExpenses extends StatefulWidget {
  const MyExpenses({super.key});

  @override
  State<MyExpenses> createState() => _MyExpensesState();
}

class _MyExpensesState extends State<MyExpenses> {
  // Stream<List<Expense>> getExpenses() {
  //   return FirebaseFirestore.instance
  //       .collection('expenses')
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs.map((doc) => Expense.fromDocument(doc)).toList();
  //   });
  // }

  Stream<QuerySnapshot> _getExpenses() {
    return FirebaseFirestore.instance
        .collection('expenses')
        .orderBy('date', descending: true)
        .snapshots();
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

  Icon getIconForCategory(String category) {
    switch (category) {
      case 'Food':
        return Icon(Icons.fastfood, color: Colors.white);
      case 'Rent':
        return Icon(Icons.house, color: Colors.white);
      case 'Transportation':
        return Icon(Icons.directions_car, color: Colors.white);
      case 'Entertainment':
        return Icon(Icons.movie, color: Colors.white);
      case 'Education':
        return Icon(Icons.book, color: Colors.white);
      case 'Monthly Shopping':
        return Icon(Icons.shop, color: Colors.white);
      case 'Medicine':
        return Icon(Icons.medical_information, color: Colors.white);
      case 'other':
        return Icon(Icons.food_bank_sharp, color: Colors.white);
      default:
        return Icon(Icons.category, color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      appBar: AppBar(
        title: Text(
          "My Expenses",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10.0),
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 143, 123, 145),
              // image: DecorationImage(
              //   image: NetworkImage(
              //       "https://user-images.githubusercontent.com/54882818/130562917-33168e1a-beba-410a-a986-0fff4f117a6b.png"),
              // ),
            ),
            child: const Chart(),
          ),
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
                  child: ListView.builder(
                    itemCount: expense.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
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
                                  const Color.fromARGB(255, 141, 3, 132),
                                  const Color.fromARGB(255, 235, 35, 145),
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
                                backgroundColor: getColorForCategory(
                                    expense[index]['category']),
                                child: getIconForCategory(
                                    expense[index]['category']),
                              ),
                              title: Text(
                                expense[index]['title'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                '\$${expense[index]['amount'].toString()}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              onTap: () {
                                // Navigate to EditExpenseScreen
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditExpenseScreen(
                                      expense: Expense(
                                        id: expense[index].id,
                                        title: expense[index]['title'],
                                        amount: expense[index]['amount'],
                                        category: expense[index]['category'],
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
                      );
                    },
                  ),
                );
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return AddExpense();
            },
          ));
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(
            color: Colors.white,
            width: 3,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 250, 13, 246),
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 50,
        color: Theme.of(context).colorScheme.primary,
        child: Container(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

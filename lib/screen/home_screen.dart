import 'package:flutter/material.dart';

import 'package:my_expense_tracker_app/screen/chart_screen.dart';
import 'package:my_expense_tracker_app/screen/my_expenses.dart';
import 'package:my_expense_tracker_app/screen/select_category_screen.dart';
import 'package:my_expense_tracker_app/screen/select_income_screen.dart';
import 'package:my_expense_tracker_app/screen/settings.dart';

import 'package:my_expense_tracker_app/screen/summary_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabController,
      curve: Curves.elasticOut,
    );
    _fabController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  DateTime _selectedMonth = DateTime.now();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _updateSelectedMonth(DateTime newMonth) {
    setState(() {
      _selectedMonth = newMonth;
    });
  }

  void _showPopup(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 200,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return SelectIncomeScreen(
                                      selectedMonth: _selectedMonth);
                                },
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                                // backgroundColor:
                                //     Theme.of(context).colorScheme.primary,
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(20.0),
                                // ),
                                // foregroundColor: Colors.white,
                                ),
                            child: const Text(
                              'Add Income',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return SelectCategoryScreen();
                                },
                              ));
                            },
                            style: ElevatedButton.styleFrom(),
                            child: const Text(
                              'Add Expense',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = <Widget>[
      SummaryScreen(
        selectedMonth: _selectedMonth,
        onMonthChanged: _updateSelectedMonth,
      ),
      MyExpenses(
        selectedMonth: _selectedMonth,
      ),
      ChartScreen(
        selectedMonth: _selectedMonth,
      ),
      SettingsScreen()
    ];
    return Scaffold(
      body: SafeArea(child: _pages[_selectedIndex]),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(
            //   builder: (context) {
            //     return AddExpense();
            //   },
            _showPopup(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, // Place FAB in the center
      bottomNavigationBar: // Margin around the notch
          BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensures all 4 items are visible
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Summary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money_off),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Chart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.onPrimaryContainer,
        unselectedItemColor: Theme.of(context).colorScheme.primary,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}

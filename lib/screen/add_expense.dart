import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:my_expense_tracker_app/model/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _selectedCategory;
  DateTime? _selectedDate;

  // final List<String> _categories = [
  //   "Food",
  //   "Rent",
  //   "Transportation",
  //   "Entertainment",
  //   "Education",
  //   "Monthly Shopping",
  //   "Medecine",
  //   "other"
  // ];

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Food', 'color': const Color.fromARGB(255, 19, 212, 8)},
    {'name': 'Rent', 'color': const Color.fromARGB(255, 232, 9, 9)},
    {'name': 'Transportation', 'color': Colors.blue},
    {'name': 'Entertainment', 'color': const Color.fromARGB(255, 6, 125, 10)},
    {'name': 'Education', 'color': const Color.fromARGB(255, 231, 149, 9)},
    {'name': 'Monthly Shopping', 'color': Colors.yellow},
    {'name': 'Medicine', 'color': const Color.fromARGB(255, 90, 5, 114)},
    {'name': 'Other', 'color': const Color.fromARGB(255, 243, 33, 184)},
  ];

  //String _selectedCategory = 'Food';

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _selectedCategory = null;
    super.dispose();
  }

  void _clearForm() {
    _titleController.clear();
    _amountController.clear();
    setState(() {
      _selectedCategory = null;
    });
  }

  void _addExpense() async {
    if (_titleController.text.isNotEmpty &&
        _amountController.text.isNotEmpty &&
        _selectedCategory != null &&
        _selectedCategory != null) {
      double amount = double.parse(_amountController.text);
      String? category = _selectedCategory;
      DateTime? date = _selectedDate;

      Expense expense = Expense(
        id: Uuid().v4(),
        title: _titleController.text,
        amount: amount,
        category: category,
        date: date,
      );

      await FirebaseFirestore.instance
          .collection('expenses')
          .doc(expense.id)
          .set(expense.toMap());
    }
    _clearForm();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Expense',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Expense Title",
                labelStyle: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: "Amount",
                labelStyle: Theme.of(context).textTheme.titleLarge,
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: Theme.of(context).textTheme.titleLarge),
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category['name'],
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: category['color'],
                        radius: 10,
                      ),
                      SizedBox(width: 10),
                      Text(category['name']),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            DateTimeFormField(
              decoration: InputDecoration(
                labelText: 'Enter Date',
                labelStyle: Theme.of(context).textTheme.titleLarge,
              ),
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
              initialPickerDateTime: DateTime.now(),
              onChanged: (DateTime? value) {
                _selectedDate = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: _addExpense, child: Text("Add Expense"))
          ],
        ),
      ),
    );
  }
}

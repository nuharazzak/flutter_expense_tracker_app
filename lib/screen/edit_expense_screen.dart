import 'package:flutter/material.dart';
import 'package:my_expense_tracker_app/model/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;
  const EditExpenseScreen({super.key, required this.expense});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late double _amount;
  late String? _category;
  late DateTime? _date;

  @override
  void initState() {
    _title = widget.expense.title;
    _amount = widget.expense.amount;
    _category = widget.expense.category;
    _date = widget.expense.date;

    super.initState();
  }

  Future<void> _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedExpense = Expense(
        id: widget.expense.id,
        title: _title,
        amount: _amount,
        category: _category,
        date: _date,
      );

      try {
        // Update the expense in Firestore
        await FirebaseFirestore.instance
            .collection('expenses')
            .doc(updatedExpense.id)
            .update(updatedExpense.toMap());

        // Close the screen after saving
        Navigator.of(context).pop();
      } catch (error) {
        // Handle errors (e.g., show a snackbar)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update expense: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Expense'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveExpense,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) {
                  _title = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title.';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _amount.toString(),
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _amount = double.parse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                onSaved: (value) {
                  _category = value;
                },
              ),
              TextFormField(
                initialValue: _date?.toIso8601String(),
                decoration: const InputDecoration(labelText: 'Date'),
                onSaved: (value) {
                  _date = DateTime.tryParse(value!);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

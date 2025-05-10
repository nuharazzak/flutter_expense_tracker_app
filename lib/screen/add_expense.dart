import 'package:flutter/material.dart';
import 'package:my_expense_tracker_app/model/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class AddExpense extends StatefulWidget {
  const AddExpense({
    super.key,
    required this.category,
  });

  final Map<String, dynamic> category;

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _selectedDate = null; // Dispose of the date field controller
    super.dispose();
  }

  void _clearForm() {
    setState(() {
      _titleController.clear();
      _amountController.clear();
      _selectedDate = null;
    });
  }

  void _addExpense() async {
    if (_titleController.text.isNotEmpty &&
        _amountController.text.isNotEmpty &&
        _selectedDate != null) {
      try {
        double amount = double.parse(_amountController.text);
        String? category = widget.category['name'];
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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense added successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        _clearForm();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add expense. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields.'),
          backgroundColor: Color.fromARGB(255, 215, 243, 7),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense - ${widget.category['name']}'),
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
                labelStyle: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: "Amount",
                labelStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              readOnly: true, // Prevent manual input
              decoration: InputDecoration(
                labelText: 'Select Date',
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                suffixIcon:
                    const Icon(Icons.calendar_today), // Add a calendar icon
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate:
                      DateTime(2020), // Earliest date the user can select
                  lastDate: DateTime(2100), // Latest date the user can select
                );

                if (pickedDate != null) {
                  setState(() {
                    // Strip the time component and store only the date
                    _selectedDate = DateTime(
                        pickedDate.year, pickedDate.month, pickedDate.day);
                  });
                }
              },
              controller: TextEditingController(
                text: _selectedDate != null
                    ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                    : '',
              ), // Display the selected date in the text field
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: _addExpense,
              child: Text("Add Expense"),
            )
          ],
        ),
      ),
    );
  }
}

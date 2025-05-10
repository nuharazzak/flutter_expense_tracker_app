import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_expense_tracker_app/model/expense.dart';

class AddIncome extends StatefulWidget {
  const AddIncome({
    super.key,
    required this.income,
  });

  final Map<String, dynamic> income;

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _selectedDate = null;
    super.dispose();
  }

  void _clearForm() {
    setState(() {
      _titleController.clear();
      _amountController.clear();
      _selectedDate = null;
    });
  }

  void _addIncome() async {
    if (_titleController.text.isNotEmpty &&
        _amountController.text.isNotEmpty &&
        _selectedDate != null) {
      try {
        double amount = double.parse(_amountController.text);
        String? category = widget.income['name'];
        DateTime? date = _selectedDate;

        Map<String, dynamic> income = {
          'id': uuid.v4(),
          'title': _titleController.text,
          'amount': amount,
          'category': category,
          'date': date,
        }; // Create an income object

        await FirebaseFirestore.instance
            .collection('incomes')
            .doc(income['id'])
            .set(income); // Save to Firebase

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Income added successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        _clearForm();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add income. Please try again.'),
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
        title: Text(
          'Add Income - ${widget.income['name']}',
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Income Title",
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
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              //controller: _titleController,
              decoration: InputDecoration(
                labelText: "Select Date",
                labelStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
              controller: TextEditingController(
                text: _selectedDate != null
                    ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                    : '',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addIncome,
              child: const Text("Add Income"),
            ),
          ],
        ),
      ),
    );
  }
}

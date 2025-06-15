import 'package:flutter/material.dart';
import 'package:my_expense_tracker_app/model/income.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditIncomeScreen extends StatefulWidget {
  final Income income;
  const EditIncomeScreen({super.key, required this.income});

  @override
  State<EditIncomeScreen> createState() => _EditIncomeScreenState();
}

class _EditIncomeScreenState extends State<EditIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late double _amount;
  late String? _category;
  late DateTime? _date;
  DateTime? _selectedDate;

  @override
  void initState() {
    _title = widget.income.title;
    _amount = widget.income.amount;
    _category = widget.income.category;
    _date = widget.income.date;
    _selectedDate = widget.income.date;

    super.initState();
  }

  Future<void> _saveIncome() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedExpense = Income(
        id: widget.income.id,
        title: _title,
        amount: _amount,
        category: _category,
        date: _date,
      );

      try {
        // Update the expense in Firestore
        await FirebaseFirestore.instance
            .collection('incomes')
            .doc(updatedExpense.id)
            .update(updatedExpense.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Income Updated Successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pop();
      } catch (error) {
        // Handle errors (e.g., show a snackbar)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update income: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Income'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                ),
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
              SizedBox(height: 10),
              TextFormField(
                initialValue: _amount.toString(),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                ),
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
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _category, // The currently selected category
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                ),

                items: [
                  'Salary',
                  'Business',
                  'Investments',
                  'Other',
                ].map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value; // Update the selected category
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
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
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate:
                        DateTime(2020), // Earliest date the user can select
                    lastDate: DateTime(2100), // Latest date the user can select
                  );

                  if (pickedDate != null) {
                    setState(() {
                      // Update both _selectedDate and _date
                      _selectedDate = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                      );
                      _date = _selectedDate; // Ensure _date is updated
                    });
                  }
                },
                controller: TextEditingController(
                  text: _selectedDate != null
                      ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                      : '',
                ), // Display the selected date in the text field
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveIncome,
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

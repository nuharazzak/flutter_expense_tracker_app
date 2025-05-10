import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  Future<double> _getTotal(String collectionName) async {
    double total = 0.0;

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection(collectionName).get();

      for (var doc in snapshot.docs) {
        total += (doc['amount'] as num).toDouble();
      }
    } catch (e) {
      print("Error fetching $collectionName: $e");
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Summary',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: FutureBuilder(
        future: Future.wait([
          _getTotal('incomes'),
          _getTotal('expenses'),
        ]),
        builder: (context, AsyncSnapshot<List<double>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load data'),
            );
          }
          if (snapshot.hasData) {
            double totalIncome = snapshot.data![0];
            double totalExpense = snapshot.data![1];
            double netBalance = totalIncome - totalExpense;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      'Total Income:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                    ),
                    trailing: Text(
                      'Rs ${totalIncome.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 74, 3, 56),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    title: Text(
                      'Total Expense:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                    ),
                    trailing: Text(
                      'Rs ${totalExpense.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 74, 3, 56)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(
                    color: Colors.grey,
                    thickness: 1.5,
                  ),
                  ListTile(
                    title: Text(
                      'Net Balance:',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Color.fromARGB(255, 9, 95, 12)),
                    ),
                    trailing: Text(
                      'Rs ${netBalance.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: netBalance >= 0
                            ? Color.fromARGB(255, 9, 95, 12)
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('No data available'),
          );
        },
      ),
    );
  }
}

import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const uuid = Uuid();

class Expense {
  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  final String id;
  final String title;
  final double amount;
  final String? category;
  final DateTime? date;

  // factory Expense.fromDocument(DocumentSnapshot doc) {
  //   return Expense(
  //     id: doc['id'] ?? Uuid().v4(),
  //     title: doc['title'],
  //     amount: doc['amount'],
  //     category: doc['category'],
  //     date: (doc['date'] as Timestamp).toDate(),
  //   );
  // }    // This code for retrieve data from Firebase....

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date,
    };
  } //This is for save data in FireBase....
}

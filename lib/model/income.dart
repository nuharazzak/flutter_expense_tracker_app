class Income {
  const Income({
    required this.id,
    required this.title,
    required this.amount,
    this.category,
    this.date,
  });

  final String id;
  final String title;
  final double amount;
  final String? category;
  final DateTime? date;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date,
    }; // this is for save data in firebase...
  }
}

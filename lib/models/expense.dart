class Expense {
  final String? id;
  final String userId;
  final String? categoryId;
  final String title;
  final double amount;
  final String? description;
  final DateTime date;
  final DateTime? createdAt;

  Expense({
    this.id,
    required this.userId,
    this.categoryId,
    required this.title,
    required this.amount,
    this.description,
    required this.date,
    this.createdAt,
  });

  // create expense from JSON
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      categoryId: json['category_id'] as String?,
      title: json['title'] as String,
      amount: (json['amount'] is String)
          ? double.parse(json['amount'])
          : (json['amount'] as num).toDouble(),
      description: json['description'] as String?,
      date: DateTime.parse(json['date'] as String),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  // convert expense to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'title': title,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String().split('T')[0],
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  // create a copy with updated fields
  Expense copyWith({
    String? id,
    String? userId,
    String? categoryId,
    String? title,
    double? amount,
    String? description,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Expense(id: $id, title: $title, amount: $amount, date: $date)';
  }
}
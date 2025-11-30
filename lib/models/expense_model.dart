import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  String? id;
  final String description;
  final double amount;
  final DateTime date;
  final String expenseTypeId;
  final String carId;
  final String carName;
  final String userId;

  Expense({
    this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.expenseTypeId,
    required this.carId,
    required this.carName,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      "description": description,
      "amount": amount,
      "date": date,
      "expenseTypeId": expenseTypeId,
      "carId": carId,
      "carName": carName,
      "userId": userId,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map, String documentId) {
    return Expense(
      id: documentId,
      description: map["description"] ?? "",
      amount: (map["amount"] as num?)?.toDouble() ?? 0.0,
      date: (map["date"] as Timestamp?)?.toDate() ?? DateTime.now(),
      expenseTypeId: map["expenseTypeId"] ?? "",
      carId: map["carId"] ?? "",
      carName: map["carName"] ?? "Vehículo no encontrado",
      userId: map["userId"] ?? "",
    );
  }
}

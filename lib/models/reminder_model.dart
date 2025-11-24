import 'package:cloud_firestore/cloud_firestore.dart';

class Reminder {
  String? id;
  final String? carId;
  final bool notificationSent;
  final Timestamp notifyAt;
  final bool pending;
  final String title;
  final String carName;
  final String userId;

  Reminder({
    this.id,
    required this.carId,
    required this.notificationSent,
    required this.notifyAt,
    required this.pending,
    required this.title,
    required this.carName,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      "carId": carId,
      "notificationSent": notificationSent,
      "notifyAt": notifyAt,
      "pending": pending,
      "title": title,
      "carName": carName,
      "userId": userId,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map, String documentId) {
    return Reminder(
      id: documentId,
      carId: map["carId"] ?? "",
      notificationSent: map["notificationSent"] ?? "",
      notifyAt: map["notifyAt"],
      pending: map["pending"] ?? false,
      title: map["title"] ?? "",
      carName: map["carName"] ?? "Vehículo no encontrado",
      userId: map["userId"] ?? "",
    );
  }
}

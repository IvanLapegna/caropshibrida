import 'package:caropshibrida/models/insurance_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  String? id;
  final String brand;
  final String model;
  final int anio;
  final String licensePlate;
  final String engine;
  final String transmission;
  final DateTime lastUpdate;
  String? insuranceId;
  final String userId;
  String? imageUrl;

  Car({
    this.id,
    required this.brand,
    required this.model,
    required this.anio,
    required this.licensePlate,
    required this.engine,
    required this.transmission,
    required this.userId,
    required this.lastUpdate,
    this.imageUrl,
    this.insuranceId,
  });

  Map<String, dynamic> toMap() {
    return {
      "brand": brand,
      "model": model,
      "anio": anio,
      "licensePlate": licensePlate,
      "engine": engine,
      "transmission": transmission,
      "userId": userId,
      "imageUrl": imageUrl,
      "insuranceId": insuranceId,
      "lastUpdated": lastUpdate,
    };
  }

  factory Car.fromMap(Map<String, dynamic> map, String documentId) {
    return Car(
      id: documentId,
      brand: map["brand"] ?? "",
      model: map["model"] ?? "",
      anio: map["anio"] ?? 0,
      licensePlate: map["licensePlate"] ?? "",
      engine: map["engine"] ?? "",
      transmission: map["transmission"] ?? "",
      userId: map["userId"] ?? "",
      imageUrl: map["imageUrl"] ?? "",
      insuranceId: map["insuranceId"] ?? "",
      lastUpdate: (map["lastUpdate"] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

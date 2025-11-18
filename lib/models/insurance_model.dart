import 'package:cloud_firestore/cloud_firestore.dart';

class Insurance {
  String? id;
  final String insuranceName;
  final String policyNumber;
  final DateTime expirationDate;
  final String coverage;
  final String engineNumber;
  final String chassisNumber;
  final String policyHolderName;
  String? policyFileUrl;
  String? policyFileName;
  final String carId;
  final String userId;
  final DateTime lastUpdate;

  Insurance({
    this.id,
    required this.insuranceName,
    required this.policyNumber,
    required this.expirationDate,
    required this.coverage,
    required this.engineNumber,
    required this.chassisNumber,
    required this.policyHolderName,
    required this.carId,
    required this.userId,
    required this.lastUpdate,
    this.policyFileUrl,
    this.policyFileName,
  });

  Map<String, dynamic> toMap() {
    return {
      "insuranceName": insuranceName,
      "policyNumber": policyNumber,
      "expirationDate": expirationDate,
      "coverage": coverage,
      "engineNumber": engineNumber,
      "chassisNumber": chassisNumber,
      "policyHolderName": policyHolderName,
      "userId": userId,
      "carId": carId,
      "policyFileUrl": policyFileUrl,
      "policyFileName": policyFileName,
      "lastUpdate": lastUpdate,
    };
  }

  factory Insurance.fromMap(Map<String, dynamic> map, String documentId) {
    return Insurance(
      id: documentId,
      insuranceName: map["insuranceName"] ?? "",
      policyNumber: map["policyNumber"] ?? "",
      expirationDate:
          (map["expirationDate"] as Timestamp?)?.toDate() ?? DateTime.now(),
      coverage: map["coverage"] ?? "",
      engineNumber: map["engineNumber"] ?? "",
      chassisNumber: map["chassisNumber"] ?? "",
      userId: map["userId"] ?? "",
      carId: map["carId"] ?? "",
      policyHolderName: map["policyHolderName"] ?? "",
      policyFileUrl: map["policyFileUrl"] ?? "",
      policyFileName: map["policyFileName"] ?? "",
      lastUpdate: (map["lastUpdate"] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

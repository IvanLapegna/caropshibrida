import 'dart:io';

import 'package:caropshibrida/models/insurance_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class InsuranceService {
  final CollectionReference _insurancesCollection = FirebaseFirestore.instance
      .collection("insurances");

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addInsurance(Insurance insurance, PlatformFile? file) async {
    try {
      DocumentReference docRef = _insurancesCollection.doc();

      insurance.id = docRef.id;

      if (file != null) {
        final uploadResult = await uploadPolicyFile(
          platformFile: file,
          userId: insurance.userId,
          carId: insurance.carId,
        );

        insurance.policyFileUrl = uploadResult['url'];
        insurance.policyFileName = uploadResult['name'];
      }

      await docRef.set(insurance.toMap());

      await FirebaseFirestore.instance
          .collection('cars')
          .doc(insurance.carId)
          .update({'insuranceId': docRef.id});
    } catch (e) {
      print("Error al agregar el vehiculo: $e");
    }
  }

  Future<void> updateInsurance(Insurance insurance, PlatformFile? file) async {
    try {
      if (file != null) {
        final uploadResult = await uploadPolicyFile(
          platformFile: file,
          userId: insurance.userId,
          carId: insurance.carId,
          oldUrl: insurance.policyFileUrl,
        );

        insurance.policyFileUrl = uploadResult['url'];
        insurance.policyFileName = uploadResult['name'];
      }
      await _insurancesCollection.doc(insurance.id).update(insurance.toMap());
    } catch (e) {
      print("Error al actualizar el seguro: $e");
    }
  }

  Stream<Insurance?> getInsuranceByCarId(String carId) {
    return _insurancesCollection
        .where('carId', isEqualTo: carId)
        .snapshots()
        .map((snapshot) {
          final docData = snapshot.docs.first.data() as Map<String, dynamic>;

          return Insurance.fromMap(docData, snapshot.docs.first.id);
        });
  }

  Future<void> deleteCar(String insuranceId) async {
    try {
      await _insurancesCollection.doc(insuranceId).delete();
    } catch (e) {
      print('Error al eliminar el seguro: $e');
    }
  }

  Future<Map<String, String>> uploadPolicyFile({
    required PlatformFile platformFile, // <--- Recibimos esto ahora
    required String userId,
    required String carId,
    String? oldUrl,
  }) async {
    try {
      // 1. Referencia Storage
      String originalName = platformFile.name;
      String extension = originalName.toLowerCase().endsWith('.pdf')
          ? '.pdf'
          : '.jpg';
      String storagePath =
          'policies/$userId/$carId/${DateTime.now().millisecondsSinceEpoch}_$originalName';
      Reference ref = _storage.ref().child(storagePath);

      // 2. Metadata
      SettableMetadata metadata = SettableMetadata(
        contentType: extension == '.pdf' ? 'application/pdf' : 'image/jpeg',
      );

      UploadTask task;

      // 3. LÓGICA HÍBRIDA (WEB vs MÓVIL)
      if (kIsWeb) {
        // EN WEB: Usamos los bytes (platformFile.bytes)
        if (platformFile.bytes == null) {
          throw Exception("No se pudieron leer los bytes del archivo (Web)");
        }
        task = ref.putData(platformFile.bytes!, metadata);
      } else {
        // EN MÓVIL: Podemos usar putFile si queremos, o putData también.
        // putFile es más eficiente para archivos grandes en móvil.
        if (platformFile.path == null) {
          throw Exception("Ruta de archivo inválida");
        }
        task = ref.putFile(File(platformFile.path!), metadata);
      }

      // 4. Esperar subida
      TaskSnapshot snapshot = await task;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return {'url': downloadUrl, 'name': originalName};
    } catch (e) {
      print("Error subiendo archivo: $e");
      rethrow;
    }
  }
}

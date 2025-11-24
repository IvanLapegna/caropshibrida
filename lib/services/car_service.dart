import 'dart:typed_data';
import 'package:caropshibrida/models/car_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'reminder_service.dart';

class CarService {
  final CollectionReference _carsCollection = FirebaseFirestore.instance
      .collection("cars");

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addCar(Car car, Uint8List? imageFile) async {
    try {
      DocumentReference docRef = _carsCollection.doc();

      car.id = docRef.id;

      if (imageFile != null) {
        String fileName =
            'cars/${car.userId}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference storageRef = _storage.ref().child(fileName);

        UploadTask uploadTask = storageRef.putData(imageFile);
        TaskSnapshot snapshot = await uploadTask;

        String downloadUrl = await snapshot.ref.getDownloadURL();

        car.imageUrl = downloadUrl;
      }

      await docRef.set(car.toMap());
    } catch (e) {
      print("Error al agregar el vehiculo: $e");
    }
  }

  Stream<List<Car>> getCars(String userId) {
    return _carsCollection.where("userId", isEqualTo: userId).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return Car.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Stream<Car?> getCarById(String carId) { // Cambia el tipo de retorno a Stream<Car?>
    return _carsCollection.doc(carId).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null; // Retorna null si el documento no existe o los datos son null
      }
      // Si existe, realiza la conversión normal.
      return Car.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
    });
  }

  Future<List<Car>> getCarsFromUser(String userId) async {
    final snapshot = await _carsCollection
        .where("userId", isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) {
      return Car.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<void> updateCar(Car car, Uint8List? imageFile) async {
    try {
      if (imageFile != null) {
        await updateCarImage(
          car: car,
          newImageFile: imageFile,
          oldImageUrl: car.imageUrl,
        );
      }
      await _carsCollection.doc(car.id).update(car.toMap());
    } catch (e) {
      print("Error al actualizar el vehiculo: $e");
    }
  }

  Future<void> deleteCar(Car car) async {
    try {
      await _carsCollection.doc(car.id).delete();
      if (car.imageUrl != null){
        await deleteCarImage(car.imageUrl!);
      }
      if (car.insuranceId != null){
      await deleteInsurancePolicyCar(car.userId, car.id!);
      }
      deleteRemindersCar(car.userId, car.id!);


    } catch (e) {
      print('Error al eliminar: $e');
    }
  }

  Future<void> updateCarImage({
    required Car car,
    required Uint8List newImageFile,
    String? oldImageUrl,
  }) async {
    try {
      if (oldImageUrl != null &&
          oldImageUrl.isNotEmpty &&
          oldImageUrl.contains('firebasestorage')) {
        try {
          await _storage.refFromURL(oldImageUrl).delete();
        } catch (e) {
          print("Advertencia: No se pudo borrar la imagen anterior: $e");
        }
      }

      String filePath =
          'cars/${car.userId}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = _storage.ref().child(filePath);

      UploadTask uploadTask = ref.putData(newImageFile);
      TaskSnapshot snapshot = await uploadTask;

      String newDownloadUrl = await snapshot.ref.getDownloadURL();

      car.imageUrl = newDownloadUrl;
    } catch (e) {
      print("Error actualizando foto: $e");
      rethrow;
    }
  }

  Future <void> deleteCarImage(String imageUrl) async {
    try {
      if (imageUrl.isNotEmpty && imageUrl.contains('firebasestorage')) {
        await _storage.refFromURL(imageUrl).delete();
      }
    } catch (e) {
      print("Error al eliminar la imagen del vehiculo: $e");
    }
  }

  Future<void> deleteInsurancePolicyCar (String userId, String carId) async {
    String policyPath = 'policies/$userId/$carId';
    Reference policyRef = _storage.ref().child(policyPath);
    try {
      ListResult items = await policyRef.listAll();
      for (var item in items.items) {
        await item.delete();
      }
    } catch (e) {
      print("Error al eliminar la póliza de seguro del vehículo: $e");
    }
  }

  Future<void> deleteRemindersCar(String userId, String carId) async {
    try {
      final remindersSnapshot = await FirebaseFirestore.instance
          .collection('reminders')
          .where('userId', isEqualTo: userId)
          .where('carId', isEqualTo: carId)
          .get();

      for (var doc in remindersSnapshot.docs) {
        ReminderService().deleteReminder(doc.id);
        print("Recordatorio eliminado: ${doc.id}");
      }
    } catch (e) {
      print("Error al eliminar los recordatorios del vehículo: $e");
    }
  }
}

import 'dart:typed_data';
import 'package:caropshibrida/models/car_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CarService {
  final CollectionReference _carsCollection = FirebaseFirestore.instance
      .collection("cars");

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addCar(Car car, Uint8List? imageFile) async {
    try {
      if (imageFile != null) {
        String fileName =
            'cars/${car.userId}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference storageRef = _storage.ref().child(fileName);

        UploadTask uploadTask = storageRef.putData(imageFile);
        TaskSnapshot snapshot = await uploadTask;

        String downloadUrl = await snapshot.ref.getDownloadURL();

        car.imageUrl = downloadUrl;
      }

      await _carsCollection.add(car.toMap());
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

  Future<void> updateCar(Car car) async {
    try {
      await _carsCollection.doc(car.id).update(car.toMap());
    } catch (e) {
      print("Error al actualizar el vehiculo: $e");
    }
  }

  Future<void> deleteCar(String carId) async {
    try {
      await _carsCollection.doc(carId).delete();
    } catch (e) {
      print('Error al eliminar: $e');
    }
  }



  Future<Car?> getCarById(String carId) async {
    try {
      final doc = await _carsCollection.doc(carId).get();
      if (!doc.exists) return null; // no existe el documento
      final data = doc.data() as Map<String, dynamic>;
      return Car.fromMap(data, doc.id);
    } catch (e) {
      print('Error al obtener el vehiculo por id: $e');
      return null;
    }
  }
  Stream<Car?> getCarByIdStream(String carId) {
  return _carsCollection.doc(carId).snapshots().map((doc) {
    if (!doc.exists) return null;
    final data = doc.data() as Map<String, dynamic>;
    return Car.fromMap(data, doc.id);
  });
}
}

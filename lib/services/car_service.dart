import 'package:caropshibrida/models/car_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarService {
  final CollectionReference _carsCollection = FirebaseFirestore.instance
      .collection("cars");

  Future<void> addCar(Car car) async {
    try {
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
}

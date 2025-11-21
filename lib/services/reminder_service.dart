import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:caropshibrida/models/reminder_model.dart';

class ReminderService {
  final CollectionReference _remindersCollection = FirebaseFirestore.instance
      .collection("reminders");


  Future<void> addReminder(Reminder reminder) async {
    try {
      DocumentReference docRef = _remindersCollection.doc();

      reminder.id = docRef.id;

      await docRef.set(reminder.toMap());
    } catch (e) {
      print("Error al agregar el recordatorio: $e");
    }
  }

  Stream<List<Reminder>> getReminders(String userId) {
    return _remindersCollection
        .where("userId", isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Reminder.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();
        });
  }

  Stream<List<Reminder>> getRemindersForCar(String? carId) {
    return _remindersCollection
        .where("carId", isEqualTo: carId)
        .orderBy("notifyAt", descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Reminder.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();
        });
  }

  Future<void> updateReminder(Reminder reminder) async {
    try {
      await _remindersCollection.doc(reminder.id).update(reminder.toMap());
    } catch (e) {
      print("Error al actualizar el recordatorio: $e");
    }
  }

  Future<void> deleteReminder(String reminderId) async {
    try {
      await _remindersCollection.doc(reminderId).delete();
    } catch (e) {
      print("Error al eliminar el recordatorio: $e");
    }
  }


}

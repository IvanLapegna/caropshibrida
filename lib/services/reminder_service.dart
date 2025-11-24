import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:caropshibrida/models/reminder_model.dart';
import 'notification_service.dart';

class ReminderService {
  final CollectionReference _remindersCollection = FirebaseFirestore.instance
      .collection("reminders");


  Future<void> addReminder(Reminder reminder) async {
    try {
      DocumentReference docRef = _remindersCollection.doc();
      final id = docRef.id;

      reminder.id = docRef.id;
      final notifId = id.hashCode.abs();
      final DateTime dt = (reminder.notifyAt as Timestamp).toDate();
      await NotificationService().scheduleNotification(
        id: notifId,
        title: reminder.carName,
        body: reminder.title,
        scheduledDate: dt,
        payload: id,
      );
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
      final notifId = reminder.id!.hashCode.abs();
      await NotificationService().cancelNotification(notifId);
      await _remindersCollection.doc(reminder.id).update(reminder.toMap());
      final DateTime dt = (reminder.notifyAt as Timestamp).toDate();
      await NotificationService().scheduleNotification(
      id: notifId,
      title: reminder.title,
      body: reminder.carName,
      scheduledDate: dt,
      payload: reminder.id,
    );
    } catch (e) {
      print("Error al actualizar el recordatorio: $e");
    }
  }

  Future<void> deleteReminder(String reminderId) async {
    try {
      await _remindersCollection.doc(reminderId).delete();
      final notifId = reminderId.hashCode.abs();
      await NotificationService().cancelNotification(notifId);
    } catch (e) {
      print("Error al eliminar el recordatorio: $e");
    }
  }

  Future<void> reschedulePendingReminders(String userId) async {
    final now = DateTime.now();
    final snapshot = await _remindersCollection
        .where('userId', isEqualTo: userId)
        .where('notificationSent', isEqualTo: false)
        .get();

    for (final doc in snapshot.docs) {
      final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
      if (map['notifyAt'] == null) continue;

      final dt = (map['notifyAt'] as Timestamp).toDate();
      if (!dt.isAfter(now)) continue; // sólo futuras

      final notifId = doc.id.hashCode.abs();

      try {
        // evitar duplicados si ya existiera una scheduled con el mismo id
        await NotificationService().cancelNotification(notifId);

        await NotificationService().scheduleNotification(
          id: notifId,
          title: map['title'] ?? 'Recordatorio',
          body: map['carName'] ?? '',
          scheduledDate: dt,
          payload: doc.id,
        );

        print('Rescheduled reminder ${doc.id} -> $dt (notifId=$notifId)');
      } catch (e, st) {
        print('Error rescheduling reminder ${doc.id}: $e\n$st');
      }
    }
  }


}

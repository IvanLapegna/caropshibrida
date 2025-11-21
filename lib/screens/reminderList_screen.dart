import 'package:caropshibrida/models/car_model.dart';
import 'package:caropshibrida/models/reminder_model.dart';
import 'package:caropshibrida/services/auth_service.dart';
import 'package:caropshibrida/services/car_service.dart';
import 'package:caropshibrida/services/reminder_service.dart';
import 'package:caropshibrida/widgets/reminder_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderList extends StatefulWidget {
  final String? carId;
  const ReminderList({super.key, required this.carId});

  @override
  State<ReminderList> createState() => _ReminderListState();
}

class _ReminderListState extends State<ReminderList> {
  late final AuthService _authService;
  late final CarService _carService;
  late final ReminderService _reminderService;
  String? _userId;

  @override
  void initState() {
    super.initState();

    _authService = context.read<AuthService>();
    _carService = context.read<CarService>();
    _reminderService = context.read<ReminderService>();
    _userId = _authService.currentUser?.uid;

  }

  @override
  Widget build(BuildContext context) {
    final String? carid = widget.carId;
    final stream = (carid != null)
      ? _reminderService.getRemindersForCar(carid)
      : _reminderService.getReminders(_userId!);
    
    debugPrint("ReminderList.build: carId = $carid");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Recordatorios'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Inspeccionar reminders (debug)',
            icon: const Icon(Icons.bug_report),
            onPressed: () => debugInspectRemindersForCar(widget.carId),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            height: 3.0,
            width: 120,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      
      body: StreamBuilder<List<Reminder>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error.toString()}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No tienes recordatorios.\nVe a la sección 'Mis Vehículos' para añadir uno desde el detalle de tu auto.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          if (snapshot.hasData) {
            print("Reminders encontrados: ${snapshot.data!.length}");
          }

          final reminders = snapshot.data!;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),

                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminders[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ReminderCard(reminder: reminder, showCarName: true),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
Future<void> debugInspectRemindersForCar(String? carId) async {
  if (carId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('carId es null — verifica el parámetro')),
    );
    return;
  }

  final col = FirebaseFirestore.instance.collection('reminders');

  try {
    // Query por STRING
    final snap1 = await col.where('carId', isEqualTo: carId).get();
    debugPrint('Query por STRING: ${snap1.docs.length} documentos.');
    for (var d in snap1.docs) {
      debugPrint('-> doc ${d.id}: ${d.data()}');
      debugPrint('   tipo carId: ${d.data()['carId']?.runtimeType}');
    }

    // Query por DocumentReference
    final carRef = FirebaseFirestore.instance.collection('cars').doc(carId);
    final snap2 = await col.where('carId', isEqualTo: carRef).get();
    debugPrint('Query por REFERENCE: ${snap2.docs.length} documentos.');
    for (var d in snap2.docs) {
      debugPrint('-> doc ${d.id}: ${d.data()}');
      debugPrint('   tipo carId: ${d.data()['carId']?.runtimeType}');
    }

    // Mostrar resultado rápido al usuario
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(
        'DEBUG: STRING=${snap1.docs.length} | REF=${snap2.docs.length} (ver consola)'
      )),
    );
  } catch (e, st) {
    debugPrint('Error debugInspect: $e\n$st');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error en debugInspect: $e')),
    );
  }
}
  
}

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
  final String? carName;
  const ReminderList({super.key, required this.carId, required this.carName});

  @override
  State<ReminderList> createState() => _ReminderListState();
}

class _ReminderListState extends State<ReminderList> {
  late final AuthService _authService;
  late final CarService _carService;
  late final ReminderService _reminderService;
  String? _userId;
  late final String? _carId;
  late final String? _carName;
  @override
  void initState() {
    super.initState();

    _authService = context.read<AuthService>();
    _carService = context.read<CarService>();
    _reminderService = context.read<ReminderService>();
    _userId = _authService.currentUser?.uid;
    _carId = widget.carId;
    _carName = widget.carName;

  }


Future<void> _showReminderSheet(BuildContext context, String? carId, [Reminder? reminder]) async {
  final isEdit = reminder != null;
  final _titleCtrl = TextEditingController(text: reminder?.title ?? '');
  DateTime? pickedDate = reminder?.notifyAt != null ? (reminder!.notifyAt as Timestamp).toDate() : null;
  TimeOfDay? pickedTime = pickedDate != null ? TimeOfDay(hour: pickedDate.hour, minute: pickedDate.minute) : null;
  final user = _authService.currentUser;

  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String formatDate(DateTime d) => "${twoDigits(d.day)}/${twoDigits(d.month)}/${d.year}";
  String formatTimeOfDay(TimeOfDay t) => "${twoDigits(t.hour)}:${twoDigits(t.minute)}";


  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      // StatefulBuilder para controlar el estado dentro del modal
      return StatefulBuilder(builder: (ctx, setModalState) {
        final canSave = _titleCtrl.text.trim().isNotEmpty && pickedDate != null && pickedTime != null;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20, // más espacio cuando aparece el teclado
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cabecera
              Row(
                children: [
                  Expanded(
                    child: Text(
                      isEdit ? 'Editar recordatorio' : 'Nuevo recordatorio',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),

              // Título
              TextField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (_) => setModalState(() {}), // refresca el estado para habilitar/deshabilitar guardar
              ),
              const SizedBox(height: 12),

              // Botones de fecha / hora
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        pickedDate == null ? 'Elegir fecha' : formatDate(pickedDate!),
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () async {
                        final dt = await showDatePicker(
                          context: ctx,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (dt != null) {
                          setModalState(() => pickedDate = dt);
                        }
                      },
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.access_time),
                      label: Text(
                        pickedTime == null ? 'Elegir hora' : formatTimeOfDay(pickedTime!),
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () async {
                        final t = await showTimePicker(
                          context: ctx,
                          initialTime: TimeOfDay.now(),
                        );
                        if (t != null) {
                          setModalState(() => pickedTime = t);
                        }
                      },
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 36),
              if (isEdit) ...[
                Row(
                  children: [
                    // Botón izquierdo: Realizado / Eliminar (abre diálogo de opciones)
                    Expanded(
                      child: 
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await _reminderService.deleteReminder(reminder.id!);
                              Navigator.of(ctx).pop();
                               ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Recordatorio eliminado')),
                              );
                            } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 230, 164, 0),
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                            
                          child: const Text('Realizado / Eliminar'),


                          
                        )


                    ),   
                    const SizedBox(width: 8),

                    Expanded(
                      child: 
                        ElevatedButton(
                          onPressed: canSave
                            ? () async {
                                final title = _titleCtrl.text.trim();
                                final dateTime = DateTime(
                                  pickedDate!.year,
                                  pickedDate!.month,
                                  pickedDate!.day,
                                  pickedTime!.hour,
                                  pickedTime!.minute,
                                );

                                try {
                                    final updated = Reminder(
                                      id: reminder!.id, // importante
                                      carId: carId ?? reminder.carId,
                                      title: title,
                                      notifyAt: Timestamp.fromDate(dateTime),
                                      notificationSent: reminder.notificationSent,
                                      pending: reminder.pending,
                                      carName: widget.carName ?? reminder.carName,
                                      userId: reminder.userId,
                                    );

                                    await _reminderService.updateReminder(updated);
                                    Navigator.of(ctx).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Recordatorio actualizado')),
                                    );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: ${e.toString()}')),
                                  );
                                }
                              }
                            : null,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text('Actualizar'),
                        ),
                      
                      
                      
                    )


                  ],
                ),




              ] else
                  ElevatedButton(
                      onPressed: canSave
                          ? () async {
                              final title = _titleCtrl.text.trim();
                              final dateTime = DateTime(
                                pickedDate!.year,
                                pickedDate!.month,
                                pickedDate!.day,
                                pickedTime!.hour,
                                pickedTime!.minute,
                              );

                              try {
                                final newReminder = Reminder(
                                  carId: carId,
                                  notificationSent: false,
                                  notifyAt: Timestamp.fromDate(dateTime),
                                  pending: false,
                                  title: title,
                                  carName: widget.carName ?? "Vehículo no encontrado",
                                  userId: user!.uid,
                                );
                                await _reminderService.addReminder(newReminder);

                                Navigator.of(ctx).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Recordatorio creado')),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Guardar'),
                    ),
              

              // Espacio extra al final para separar del borde/gesto de arrastre
              const SizedBox(height: 28),
            ],
          ),
        );
      });
    },
  );
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
                    child:
                      GestureDetector(
                        onTap: () => _showReminderSheet(context, _carId, reminder),
                        child: ReminderCard(reminder: reminder, showCarName: true),
                      )
                  );
                },
              ),
            ),
          );
        },
      ),

        
        

        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Visibility(
          visible: carid != null,
          child: FloatingActionButton(
          onPressed: () {
            _showReminderSheet(context, carid);

          },
          child: const Icon(Icons.add),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),


        ),

    );
  }
  
}

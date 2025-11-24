  // lib/services/notification_service.dart
  import 'package:flutter_local_notifications/flutter_local_notifications.dart';
  import 'package:flutter_timezone/flutter_timezone.dart';
  import 'package:timezone/data/latest_all.dart' as tzdata;
  import 'package:timezone/timezone.dart' as tz;
  import 'dart:io' show Platform;
  import 'package:permission_handler/permission_handler.dart';

  class NotificationService {
    NotificationService._privateConstructor();
    static final NotificationService _instance = NotificationService._privateConstructor();
    factory NotificationService() => _instance;

    final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

    Future<void> init() async {
      const androidInit = AndroidInitializationSettings('@drawable/logonotificacion'); // ajustá si tenés otro icon
      final iosInit = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );
      final initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

      await _plugin.initialize(initSettings,
          onDidReceiveNotificationResponse: (payload) {
        // Opcional: lógica cuando el usuario toca la notificación
        // payload?.payload contiene datos si los seteás.
      });

      // Inicializar timezone
      tzdata.initializeTimeZones();
      try {
        final TimezoneInfo tzInfo = await FlutterTimezone.getLocalTimezone();
        final String tzName = tzInfo.identifier; // p. ej. "America/Argentina/Buenos_Aires"
        tz.setLocalLocation(tz.getLocation(tzName));

      } catch (e) {
        // Fallback: si algo falla, tz.local ya queda con la configuración por defecto
        // y las TZ pueden comportarse como local system time.
        print('No se pudo obtener la timezone del dispositivo: $e');
      }

      if (Platform.isAndroid) {
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          'reminder_channel_id', // <- id (usar el mismo más abajo)
          'Recordatorios',       // nombre visible para el usuario
          description: 'Canal para recordatorios de vehículos',
          importance: Importance.max,
        );

        final androidPlugin = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
        await androidPlugin?.createNotificationChannel(channel);
      }

      if (Platform.isAndroid) {
        // Android 13+ requiere permiso runtime
        final status = await Permission.notification.status;
        if (status.isDenied) {
          final result = await Permission.notification.request();
          if (!result.isGranted) {
            // El usuario no concedió permiso
            print('Permiso de notificaciones no concedido');
          }
        }
      } else if (Platform.isIOS) {
        await _plugin
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, badge: true, sound: true);
      }

    }

    NotificationDetails _platformChannelSpecifics() {
      const androidDetails = AndroidNotificationDetails(
        'reminder_channel_id',
        'Recordatorios',
        channelDescription: 'Notificaciones de recordatorios',
        importance: Importance.max,
        priority: Priority.high,
      );

      const iosDetails = DarwinNotificationDetails();
      return const NotificationDetails(android: androidDetails, iOS: iosDetails);
    }

    Future<void> scheduleNotification({
      required int id,
      required String title,
      String? body,
      required DateTime scheduledDate,
      String? payload,
    }) async {
      // Convertir a TZ y preparar logs
      var scheduledTz = tz.TZDateTime.from(scheduledDate, tz.local);
      final tzNow = tz.TZDateTime.now(tz.local);

      // Si la fecha programada está en el pasado: loguear y ajustar (opcional)
      if (!scheduledTz.isAfter(tzNow)) {
        print('WARNING: scheduled time is in the PAST. Android normalmente no disparará esta notificación inmediatamente.');
        // OPCIONAL: reprogramar para 1 minuto en el futuro para pruebas
        scheduledTz = tzNow.add(const Duration(minutes: 1));
        print(' -> Reajustado scheduledTz para pruebas: $scheduledTz');
      }

      try {
        await _plugin.zonedSchedule(
          id,
          title,
          body,
          scheduledTz,
          _platformChannelSpecifics(),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: payload,
        );
        print('zonedSchedule programmed id=$id at $scheduledTz');
      } catch (e, st) {
        print('zonedSchedule exact falló: $e\n$st — intentando inexact');
        try {
          await _plugin.zonedSchedule(
            id,
            title,
            body,
            scheduledTz,
            _platformChannelSpecifics(),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            payload: payload,
          );
          print('zonedSchedule inexact programmed id=$id at $scheduledTz');
        } catch (e2, st2) {
          print('zonedSchedule inexact también falló: $e2\n$st2');
        }
      }
    }

    Future<void> cancelNotification(int id) async {
      await _plugin.cancel(id);
    }

    Future<void> cancelAll() async {
      await _plugin.cancelAll();
    }

  }

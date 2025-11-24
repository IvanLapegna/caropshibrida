import 'package:caropshibrida/models/car_model.dart';
import 'package:caropshibrida/models/expense_model.dart';
import 'package:caropshibrida/models/insurance_model.dart';
import 'package:caropshibrida/screens/expense_form.dart';
import 'package:caropshibrida/screens/expense_list.dart';
import 'package:caropshibrida/screens/insurance_form.dart';
import 'package:caropshibrida/screens/reminderList_screen.dart';
import 'package:caropshibrida/screens/vehicle_detail.dart';
import 'package:caropshibrida/screens/vehicle_form.dart';
import 'package:caropshibrida/services/car_service.dart';
import 'package:caropshibrida/services/expense_service.dart';
import 'package:caropshibrida/services/insurance_service.dart';
import 'package:caropshibrida/services/reminder_service.dart';
import 'services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/theme/colors.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';
import 'screens/parking_screen.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().init();

  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<CarService>(create: (_) => CarService()),
        Provider<InsuranceService>(create: (_) => InsuranceService()),
        Provider<ExpenseService>(create: (_) => ExpenseService()),
        Provider<ReminderService>(create: (_) => ReminderService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  StreamSubscription<User?>? _authSub;
  String? _rescheduledForUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthService>();
      final reminderService = context.read<ReminderService>();

      _authSub = auth.authStateChanges().listen((user) async {
        if (user != null) {
          if (_rescheduledForUserId != user.uid) {
            try {
              await reminderService.reschedulePendingReminders(user.uid);
              _rescheduledForUserId = user.uid;
              debugPrint('Reschedule pending reminders for ${user.uid}');
            } catch (e) {
              debugPrint('Error rescheduling reminders: $e');
            }
          }
        } else {
          _rescheduledForUserId = null;
        }
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _authSub?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final auth = context.read<AuthService>();
      final reminderService = context.read<ReminderService>();
      final user = auth.currentUser;
      if (user != null) {
        // no bloqueante: re-ejecutar en background
        reminderService
            .reschedulePendingReminders(user.uid)
            .then((_) {
              _rescheduledForUserId = user.uid;
              debugPrint('Rescheduled on app resume for ${user.uid}');
            })
            .catchError((e) => debugPrint('reschedule on resume failed: $e'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();

    final baseScheme = ColorScheme.fromSeed(
      seedColor: appColorsLight.button!,
      brightness: Brightness.dark,
    );

    final darkScheme = baseScheme.copyWith(
      primary: appColorsLight.button!,
      surface: appColorsLight.primary!,
    );

    return MaterialApp(
      title: 'CarOps',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        "/add-vehicle": (context) => const VehicleForm(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == "/vehicle") {
          final String id = settings.arguments as String;

          return MaterialPageRoute(
            builder: (context) => CarDetailScreen(carId: id),
          );
        }

        if (settings.name == "/expenses") {
          final args = settings.arguments as Map<String, dynamic>?;
          final String? preselectedCarId = args?["preselectedCarId"];
          final String? preselectedCarName = args?["preselectedCarName"];

          return MaterialPageRoute(
            builder: (context) => ExpenseList(
              preselectedCarId: preselectedCarId,
              preselectedCarName: preselectedCarName,
            ),
          );
        }

        if (settings.name == "/edit-vehicle") {
          final Car car = settings.arguments as Car;

          return MaterialPageRoute(builder: (context) => VehicleForm(car: car));
        }

        if (settings.name == "/add-insurance") {
          final String carId = settings.arguments as String;

          return MaterialPageRoute(
            builder: (context) => InsuranceForm(carId: carId),
          );
        }

        if (settings.name == "/edit-insurance") {
          final args = settings.arguments as Map<String, dynamic>;

          final String carId = args["carId"];

          final Insurance insurance = args["insurance"];

          return MaterialPageRoute(
            builder: (context) =>
                InsuranceForm(carId: carId, insurance: insurance),
          );
        }

        if (settings.name == "/add-expense") {
          final args = settings.arguments as Map<String, dynamic>;
          final String carId = args["carId"];
          final String carName = args["carName"];

          return MaterialPageRoute(
            builder: (context) => ExpenseForm(carId: carId, carName: carName),
          );
        }

        if (settings.name == "/edit-expense") {
          final args = settings.arguments as Map<String, dynamic>;
          final String carId = args["carId"];
          final String carName = args["carName"];
          final Expense expense = args["expense"];

          return MaterialPageRoute(
            builder: (context) =>
                ExpenseForm(carId: carId, carName: carName, expense: expense),
          );
        }

        if (settings.name == "/parking") {
          final Car car = settings.arguments as Car;

          return MaterialPageRoute(builder: (context) => MapSample(car: car));
        }

        if (settings.name == "/reminders") {
          final args = settings.arguments as Map<String, dynamic>?;
          final String? carId = args?["carId"] as String?;
          final String? carName = args?["carName"] as String?;
          return MaterialPageRoute(
            builder: (context) => ReminderList(carId: carId, carName: carName),
          );
        }

        return null;
      },

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: darkScheme,
        scaffoldBackgroundColor: darkScheme.surface,

        appBarTheme: AppBarTheme(
          backgroundColor: darkScheme.surface,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),

        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: appColorsLight.grayLight),
          hintStyle: TextStyle(color: appColorsLight.grayLight),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: appColorsLight.grayLight!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: appColorsLight.grayLight!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: darkScheme.primary),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: darkScheme.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16.0),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),

        extensions: <ThemeExtension<dynamic>>[appColorsLight],
      ),
      home: StreamBuilder<User?>(
        stream: authService.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) return const HomeScreen();
          return const LoginScreen();
        },
      ),
    );
  }
}

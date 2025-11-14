import 'package:caropshibrida/models/car_model.dart';
import 'package:caropshibrida/screens/vehicle_card.dart';
import 'package:caropshibrida/services/auth_service.dart';
import 'package:caropshibrida/services/car_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AuthService _authService;
  late final CarService _carService;
  String? _userId;

  @override
  void initState() {
    super.initState();

    _authService = context.read<AuthService>();
    _carService = context.read<CarService>();
    _userId = _authService.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Vehículos'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Car>>(
        stream: _carService.getCars(_userId!),
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
                "No tienes vehículos.\nPresiona (+) para añadir uno.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final cars = snapshot.data!;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),

                itemCount: cars.length,
                itemBuilder: (context, index) {
                  final car = cars[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: VehicleCard(
                      car: "${car.brand} ${car.model}",
                      licensePlate: car.licensePlate,
                      image: car.imageUrl,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: BottomAppBar(
        // Usamos el color de fondo de tu tema
        color: Theme.of(context).colorScheme.surface,
        elevation: 0, // Sin sombra, para que se integre
        // Usamos un Row para poner los 3 botones
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Espaciarlos
          children: [
            // Botón de Gastos
            IconButton(
              icon: const Icon(Icons.attach_money),
              iconSize: 28.0,
              tooltip: 'Gastos',
              onPressed: () {
                Navigator.pushNamed(context, "/money");
              },
            ),

            IconButton(
              icon: const Icon(Icons.add_circle),
              iconSize: 28.0,
              tooltip: 'Añadir Vehículo',
              onPressed: () {
                Navigator.pushNamed(context, "/add-vehicle");
              },
            ),

            // Botón de Ajustes
            IconButton(
              icon: const Icon(Icons.settings),
              iconSize: 28.0,
              tooltip: 'Ajustes',
              onPressed: () {
                // ¡Recuerda definir esta ruta en MyApp.dart!
                Navigator.pushNamed(context, "/settings");
              },
            ),
          ],
        ),
      ),
    );
  }
}

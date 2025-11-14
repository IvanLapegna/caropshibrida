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

          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 80.0,
            ),
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
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/add-vehicle");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

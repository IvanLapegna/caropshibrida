import 'package:flutter/material.dart';
import 'screens/vehicule_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Vehículos',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),

      home: VehiculeForm(),
    );
  }
}

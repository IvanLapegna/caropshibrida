import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

IconData getIconForType(String typeId) {
  switch (typeId.toLowerCase()) {
    case '0':
      return Icons.local_gas_station;
    case '1':
      return Icons.security;
    case '2':
      return Icons.car_repair;
    case '3':
      return Icons.build;
    case '4':
      return Icons.local_car_wash;
    default:
      return Icons.category;
  }
}

Color getColorForType(String typeId) {
  switch (typeId.toLowerCase()) {
    case '0':
      return Colors.orangeAccent;
    case '1':
      return Colors.blueAccent;
    case '2':
      return Colors.brown;
    case '3':
      return Colors.redAccent;
    case '4':
      return Colors.cyanAccent;
    default:
      return Colors.grey;
  }
}

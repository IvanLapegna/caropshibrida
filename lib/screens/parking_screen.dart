import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:caropshibrida/services/car_service.dart';
import 'package:provider/provider.dart';



class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late final CarService _carService;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  CameraPosition _initialCamera = const CameraPosition(
      target: LatLng(-34.6037, -58.3816), zoom: 12);

  Marker? _currentMarker;
  Marker? _carMarker; // marcador del auto (puede apuntar a la ubicación actual)
  Position? _currentPosition;
  bool _loading = true;
  String? _error;

  // El id pedido
  final String _carIdToFind = 'dBGul4Ud44paVEq9M1VK';

  @override
  void initState() {
    super.initState();
    _carService = context.read<CarService>();
    _init(); // no await aquí, _init hace el trabajo async
  }

  Future<void> _init() async {
  setState(() {
    _loading = true;
    _error = null;
  });

  // intentamos mostrar el auto primero; si devuelve false pedimos la ubicación actual
  final bool carShown = await _loadCarById(_carIdToFind);

  if (!carShown) {
    await _determinePositionAndMove();
  } else {
    // ya mostramos el auto, solo cerramos loader
    setState(() {
      _loading = false;
    });
  }
}

  Future<void> _determinePositionAndMove() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _error = 'El servicio de ubicación está desactivado.';
          _loading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _error = 'Permiso de ubicación denegado.';
            _loading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _error =
              'Permiso de ubicación denegado permanentemente. Habilitalo desde ajustes.';
          _loading = false;
        });
        return;
      }

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      _currentPosition = pos;
      _currentMarker = Marker(
        markerId: const MarkerId('current_pos'),
        position: LatLng(pos.latitude, pos.longitude),
        infoWindow: const InfoWindow(title: 'Tu ubicación'),
      );

      final GoogleMapController mapController = await _controller.future;
      final CameraPosition cameraPosition =
          CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 17);
      mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      setState(() {
        _initialCamera = cameraPosition;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al obtener ubicación: $e';
        _loading = false;
      });
    }
  }

  Future<void> _goToCurrentLocation() async {
    if (_currentPosition == null) {
      await _determinePositionAndMove();
      return;
    }
    final GoogleMapController mapController = await _controller.future;
    final CameraPosition cameraPosition = CameraPosition(
      target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      zoom: 17,
    );
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
  }

 Future<bool> _loadCarById(String carId) async {
  try {
    final doc = await FirebaseFirestore.instance.collection('cars').doc(carId).get();

    if (!doc.exists) {
      setState(() {
        _error = 'No existe el auto con id $carId';
      });
      return false;
    }

    final data = doc.data();
    if (data == null) {
      setState(() {
        _error = 'Documento vacío para el auto $carId';
      });
      return false;
    }

    final bool parked = data['parked'] == true;

    // Si no está marcado como estacionado -> devolvemos false para que se muestre la ubicación actual
    if (!parked) return false;

    // Si está estacionado, intentamos obtener las coordenadas guardadas
    double? lat = (data['parkedLat'] as num?)?.toDouble();
    double? lng = (data['parkedLng'] as num?)?.toDouble();
    if ((lat == null || lng == null) && data['location'] is GeoPoint) {
      final gp = data['location'] as GeoPoint;
      lat = gp.latitude;
      lng = gp.longitude;
    }

    if (lat == null || lng == null) {
      // No hay coords válidas -> devolvemos false para usar la ubicación actual
      return false;
    }

    final LatLng carLat = LatLng(lat, lng);

    final marker = Marker(
      markerId: MarkerId('car_$carId'),
      position: carLat,
      infoWindow: InfoWindow(title: 'Auto $carId (parked)'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );

    setState(() {
      _carMarker = marker;
      _error = null;
      _initialCamera = CameraPosition(target: carLat, zoom: 17);
    });

    // Si el mapa ya está creado, movemos la cámara
    if (_controller.isCompleted) {
      final ctrl = await _controller.future;
      await ctrl.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: carLat, zoom: 17),
      ));
    }

    return true; // mostramos el auto y ya movimos la cámara
  } catch (e) {
    setState(() {
      _error = 'Error buscando el auto: $e';
    });
    return false;
  }
}


  // construye el set de markers combinando ubicación actual y auto (si existen)
  Set<Marker> _buildMarkers() {
    final m = <Marker>{};
    if (_currentMarker != null) m.add(_currentMarker!);
    if (_carMarker != null) m.add(_carMarker!);
    return m;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('¿Donde Estacione?'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCamera,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            markers: _buildMarkers(),
            onMapCreated: (GoogleMapController controller) {
              if (!_controller.isCompleted) _controller.complete(controller);
              if (_carMarker != null) {
                controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: _carMarker!.position, zoom: 17)));
              }
            },
          ),
          if (_loading) const Center(child: CircularProgressIndicator()),
          if (_error != null)
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Card(
                color: Colors.red.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'center',
            onPressed: _goToCurrentLocation,
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'refresh',
            onPressed: () {
              _determinePositionAndMove();
              _loadCarById(_carIdToFind); // refresca tambien la busqueda del auto
            },
            mini: true,
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

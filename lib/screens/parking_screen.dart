import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:caropshibrida/services/car_service.dart';
import 'package:provider/provider.dart';
import '../src/theme/colors.dart';
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

  Marker? _carMarker; // marcador que representa donde está el auto (guardado o provisional)
  Position? _currentPosition;
  bool _loading = true;
  String? _error;

  // controla si el botón guardar está habilitado
  bool _canSave = false;

  // El id pedido
  final String _carIdToFind = 'dBGul4Ud44paVEq9M1VK';

  @override
  void initState() {
    super.initState();
    _carService = context.read<CarService>();
    _init();
  }

  Future<void> _init() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    // intentamos mostrar el auto primero; si devuelve false pedimos la ubicación actual
    final bool carShown = await _loadCarById(_carIdToFind);

    if (!carShown) {
      // No mostramos marcador de la ubicación actual: solo centramos la cámara
      await _determinePositionAndMove();
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  // helper que solicita permisos y devuelve la posición actual o null si falló
  Future<Position?> _fetchCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _error = 'El servicio de ubicación está desactivado.';
        });
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _error = 'Permiso de ubicación denegado.';
          });
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _error =
              'Permiso de ubicación denegado permanentemente. Habilitalo desde ajustes.';
        });
        return null;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      return pos;
    } catch (e) {
      setState(() {
        _error = 'Error al obtener ubicación: $e';
      });
      return null;
    }
  }

  // centra la cámara en la ubicación actual SIN crear marcador
  Future<void> _determinePositionAndMove() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final pos = await _fetchCurrentPosition();
    if (pos == null) {
      setState(() {
        _loading = false;
      });
      return;
    }

    _currentPosition = pos;

    final GoogleMapController mapController = await _controller.future;
    final CameraPosition cameraPosition =
        CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 17);
    await mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    setState(() {
      _initialCamera = cameraPosition;
      _loading = false;
    });
  }

  // centra la cámara en la ubicación actual (si ya tenemos _currentPosition) sin pedir permisos de nuevo
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

  // Al presionar "Actualizar": pedimos la ubicación, creamos un marker provisional en esa ubicación
  // y habilitamos el botón "Guardar".
  Future<void> _actualizarUbicacion() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final pos = await _fetchCurrentPosition();
    if (pos == null) {
      setState(() {
        _loading = false;
      });
      return;
    }

    _currentPosition = pos;

    final LatLng posLatLng = LatLng(pos.latitude, pos.longitude);

    final marker = Marker(
      markerId: const MarkerId('car_provisional'),
      position: posLatLng,
      infoWindow: const InfoWindow(title: 'Ubicación seleccionada'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    final GoogleMapController mapController = await _controller.future;
    final CameraPosition cameraPosition =
        CameraPosition(target: posLatLng, zoom: 17);
    await mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    setState(() {
      _carMarker = marker;
      _canSave = true;
      _loading = false;
      _error = null;
    });
  }

  // Guarda en Firestore los campos parkingDate, parkedLat, parkedLng y parked = true
  Future<void> _guardarParking() async {
    if (_carMarker == null) {
      setState(() {
        _error = 'No hay ubicación para guardar. Presiona Actualizar primero.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final lat = _carMarker!.position.latitude;
      final lng = _carMarker!.position.longitude;

      await FirebaseFirestore.instance
          .collection('cars')
          .doc(_carIdToFind)
          .update({
        'parked': true,
        'parkedLat': lat,
        'parkedLng': lng,
        'parkingDate': Timestamp.now(),
      });

      // dejamos el marker como marcador "oficial" del auto (misma id pero se puede sobrescribir)
      final savedMarker = Marker(
        markerId: MarkerId('car_${_carIdToFind}'),
        position: LatLng(lat, lng),
        infoWindow: const InfoWindow(title: 'Estacionado aquí'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );

      setState(() {
        _carMarker = savedMarker;
        _canSave = false; // ya guardamos
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al guardar en Firestore: $e';
        _loading = false;
      });
    }
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

  // construye el set de markers (ahora SOLO mostramos el marcador del auto si existe).
  Set<Marker> _buildMarkers() {
    final m = <Marker>{};
    if (_carMarker != null) m.add(_carMarker!);
    return m;
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = 16.0 + MediaQuery.of(context).padding.bottom;
    final appColors = Theme.of(context).extension<AppColors>() ?? appColorsLight;
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

          Positioned(
            left: 12,
            bottom: bottomPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FloatingActionButton.extended(
                  heroTag: 'actualizar',
                  onPressed: _actualizarUbicacion,
                  backgroundColor: appColors.button,
                  label: const Text('Actualizar'),
                  icon: const Icon(Icons.edit_location_alt),
                ),
                const SizedBox(height: 10),
                IgnorePointer(
                  ignoring: !_canSave || _loading,
                  child: Opacity(
                    opacity: (_canSave && !_loading) ? 1.0 : 0.8,
                    child: FloatingActionButton.extended(
                      heroTag: 'guardar',
                      onPressed: _guardarParking,
                      backgroundColor: appColors.green,
                      label: const Text('Guardar'),
                      icon: const Icon(Icons.save),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
          right: 12,
          bottom: bottomPadding,
          child: FloatingActionButton(
            heroTag: 'mostrar',
            onPressed: _goToCurrentLocation,
            backgroundColor: appColors.button,
            child: const Icon(Icons.my_location),
            
          ),
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

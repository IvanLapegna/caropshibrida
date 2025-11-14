import 'dart:io';
import 'package:caropshibrida/models/car_model.dart';
import 'package:caropshibrida/services/car_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:caropshibrida/services/auth_service.dart';
import 'package:provider/provider.dart';

class VehicleForm extends StatefulWidget {
  const VehicleForm({super.key});

  @override
  _VehicleFormState createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleForm> {
  final _formKey = GlobalKey<FormState>();

  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _anioController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _engineController = TextEditingController();
  final _transmissionController = TextEditingController();

  Uint8List? _selectedImage;

  late final AuthService _authService;
  late final CarService _carService;

  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _authService = context.read<AuthService>();
    _carService = context.read<CarService>();
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _anioController.dispose();
    _licensePlateController.dispose();
    _engineController.dispose();
    _transmissionController.dispose();
    super.dispose();
  }

  Future<void> _selectImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImage = bytes;
        });
      }
    } catch (e) {
      print("Error al seleccionar imagen: $e");
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final user = _authService.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: No has iniciado sesión.')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      Car newCar = Car(
        userId: user.uid,
        brand: _brandController.text,
        model: _modelController.text,
        anio: int.parse(_anioController.text),
        licensePlate: _licensePlateController.text,
        engine: _engineController.text,
        transmission: _transmissionController.text,
      );

      try {
        await _carService.addCar(newCar, _selectedImage);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Vehículo guardado con éxito.')));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }

      _formKey.currentState!.reset();
      _brandController.clear();
      _modelController.clear();
      _anioController.clear();
      _licensePlateController.clear();
      _engineController.clear();
      _transmissionController.clear();
      setState(() {
        _selectedImage = null;
      });
    }
  }

  void _showDialogOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Galería / Explorador de archivos"),
                onTap: () {
                  _selectImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),

              if (!kIsWeb)
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text("Cámara"),
                  onTap: () {
                    _selectImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Añadir Vehículo"),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            height: 3.0,
            width: 120,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _brandController,
                    decoration: InputDecoration(
                      labelText: "Marca",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa la marca';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  TextFormField(
                    controller: _modelController,
                    decoration: InputDecoration(
                      labelText: "Modelo",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa el modelo';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  TextFormField(
                    controller: _anioController,
                    decoration: InputDecoration(
                      labelText: "Año",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa el año';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingresa un año válido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  TextFormField(
                    controller: _licensePlateController,
                    decoration: InputDecoration(
                      labelText: "Patente",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa la patente';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  TextFormField(
                    controller: _engineController,
                    decoration: InputDecoration(
                      labelText: "Motor",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa el motor';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  TextFormField(
                    controller: _transmissionController,
                    decoration: InputDecoration(
                      labelText: "Transmisión",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa la transmisión';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: _selectedImage == null
                          ? Text('Ninguna imagen seleccionada.')
                          : Image.memory(_selectedImage!, fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  OutlinedButton.icon(
                    icon: Icon(Icons.camera_alt),
                    label: Text("Seleccionar Imagen"),
                    onPressed: _showDialogOptions,
                  ),
                  SizedBox(height: 32.0),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Añadir vehículo'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:caropshibrida/models/car_model.dart';
import 'package:caropshibrida/services/car_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:caropshibrida/services/auth_service.dart';
import 'package:provider/provider.dart';

class VehicleForm extends StatefulWidget {
  final Car? car;

  const VehicleForm({super.key, this.car});

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

  Car? _car;

  bool _isLoading = false;
  bool _isEdit = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _authService = context.read<AuthService>();
    _carService = context.read<CarService>();
    _car = widget.car;
    if (_car != null) {
      loadFields(_car!);
      setState(() {
        _isEdit = true;
      });
    }
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

  void loadFields(Car car) {
    setState(() {
      _brandController.text = car.brand;
      _modelController.text = car.model;
      _anioController.text = car.anio.toString();
      _licensePlateController.text = car.licensePlate;
      _engineController.text = car.engine;
      _transmissionController.text = car.transmission;
    });
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
        id: _car?.id,
        userId: user.uid,
        brand: _brandController.text.toUpperCase(),
        model: _modelController.text.toUpperCase(),
        anio: int.parse(_anioController.text),
        licensePlate: _licensePlateController.text.toUpperCase(),
        engine: _engineController.text.toUpperCase(),
        transmission: _transmissionController.text.toUpperCase(),
        lastUpdate: DateTime.now(),
        imageUrl: _car?.imageUrl,
      );

      if (_isEdit) {
        try {
          await _carService.updateCar(newCar, _selectedImage);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Vehículo guardado con éxito.')),
          );
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        try {
          await _carService.addCar(newCar, _selectedImage);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Vehículo creado con éxito.')));
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error al crear: $e')));
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
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
        title: Text(_isEdit ? "Editar Vehículo" : "Añadir Vehículo"),
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

                  Center(
                    child: Container(
                      // 1. EL MARCO EXTERNO (La Tarjeta)
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent, // Fondo blanco (el marco)
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ), // Bordes externos redondeados
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.1,
                            ), // Sombra suave
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      // 2. EL ESPACIO INTERNO (El margen blanco)
                      // Esto hace que la foto no ocupe la "totalidad", dejando un marco blanco
                      padding: const EdgeInsets.all(12.0),

                      child: Stack(
                        children: [
                          // 3. LA IMAGEN (Contenido)
                          SizedBox.expand(
                            // Obliga a ocupar todo el espacio interno disponible
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                12.0,
                              ), // Redondeo interno de la foto
                              child:
                                  _buildImagePreview(), // Llamamos a tu función
                            ),
                          ),

                          // 4. EL BOTÓN DE CAMARA (Badge)
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Material(
                              color: Theme.of(
                                context,
                              ).primaryColor, // Color de tu app
                              shape: const CircleBorder(),
                              elevation: 4,
                              child: InkWell(
                                onTap:
                                    _showDialogOptions, // Acción al tocar el botoncito
                                customBorder: const CircleBorder(),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // 5. TOUCH INVISIBLE (Para que se pueda tocar toda la foto también)
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _showDialogOptions,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32.0),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              _isEdit ? "Guardar cambios" : "Añadir vehículo",
                            ),
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

  Widget _buildImagePreview() {
    if (_selectedImage != null) {
      return Image.memory(_selectedImage!, fit: BoxFit.contain);
    }

    if (_car != null && _car!.imageUrl != null && _car!.imageUrl!.isNotEmpty) {
      return Image.network(
        _car!.imageUrl!,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,

        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, color: Colors.grey),
              Text("Error al cargar"),
            ],
          );
        },
      );
    }
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image_not_supported_outlined, size: 40, color: Colors.grey),
        SizedBox(height: 8),
        Text(
          'Ninguna imagen seleccionada.',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

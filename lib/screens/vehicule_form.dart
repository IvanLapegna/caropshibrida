import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class VehiculeForm extends StatefulWidget {
  const VehiculeForm({Key? key}) : super(key: key);

  @override
  _VehiculeFormState createState() => _VehiculeFormState();
}

class _VehiculeFormState extends State<VehiculeForm> {
  final _formKey = GlobalKey<FormState>();

  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _anioController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _engineController = TextEditingController();
  final _transmissionController = TextEditingController();

  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

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
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error al seleccionar imagen: $e");
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String brand = _brandController.text;
      String model = _modelController.text;
      int anio = int.parse(_anioController.text);
      String licensePlate = _licensePlateController.text;
      String engine = _engineController.text;
      String transmission = _transmissionController.text;

      if (_selectedImage != null) {
        print("Path de la imagen: ${_selectedImage!.path}");
      } else {
        print("No se seleccionó ninguna imagen.");
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Vehículo guardado con éxito.')));

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
      appBar: AppBar(title: Text("Crear Nuevo Vehículo"), centerTitle: true),
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
                          : kIsWeb // Manejo de imagen para Web vs Mobile
                          ? Image.network(
                              _selectedImage!.path,
                              fit: BoxFit.cover,
                            )
                          : Image.file(_selectedImage!, fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  OutlinedButton.icon(
                    icon: Icon(Icons.camera_alt),
                    label: Text("Seleccionar Imagen"),
                    onPressed: _showDialogOptions,
                  ),
                  SizedBox(height: 32.0),

                  // --- BOTÓN DE ENVIAR ---
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Guardar Vehículo'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: TextStyle(fontSize: 16),
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

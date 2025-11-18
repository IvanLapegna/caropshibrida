
import 'package:caropshibrida/models/insurance_model.dart';
import 'package:caropshibrida/services/auth_service.dart';
import 'package:caropshibrida/services/insurance_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InsuranceForm extends StatefulWidget {
  final String carId;
  final Insurance? insurance;
  const InsuranceForm({super.key, required this.carId, this.insurance});

  @override
  _InsuranceFormState createState() => _InsuranceFormState();
}

class _InsuranceFormState extends State<InsuranceForm> {
  final _formKey = GlobalKey<FormState>();

  final _insuranceNameController = TextEditingController();
  final _policyNumberController = TextEditingController();
  final _expirationDateController = TextEditingController();
  final _coverageController = TextEditingController();
  final _engineNumberController = TextEditingController();
  final _chassisNumberController = TextEditingController();
  final _policyHolderNameController = TextEditingController();

  Insurance? _insurance;
  late final AuthService _authService;
  late final InsuranceService _insuranceService;

  PlatformFile? _selectedFile;
  String? _selectedFileName;

  DateTime? _selectedDate;

  bool _isLoading = false;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _authService = context.read<AuthService>();
    _insuranceService = context.read<InsuranceService>();
    _insurance = widget.insurance;
    if (_insurance != null) {
      loadFields(_insurance!);
      setState(() {
        _isEdit = true;
      });
    }
  }

  @override
  void dispose() {
    _insuranceNameController.dispose();
    _policyNumberController.dispose();
    _expirationDateController.dispose();
    _coverageController.dispose();
    _engineNumberController.dispose();
    _chassisNumberController.dispose();
    _policyHolderNameController.dispose();
    super.dispose();
  }

  void loadFields(Insurance insurance) {
    setState(() {
      _selectedDate = insurance.expirationDate;
      _insuranceNameController.text = insurance.insuranceName;
      _policyNumberController.text = insurance.policyNumber;
      _expirationDateController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(_selectedDate!);
      _coverageController.text = insurance.coverage;
      _engineNumberController.text = insurance.engineNumber;
      _chassisNumberController.text = insurance.chassisNumber;
      _policyHolderNameController.text = insurance.policyHolderName;
    });
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf", "jpg", "png", "jpeg"],
      withData: true,
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
        _selectedFileName = _selectedFile!.name;
      });
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

      Insurance insurance = Insurance(
        id: _insurance?.id,
        insuranceName: _insuranceNameController.text.toUpperCase(),
        policyNumber: _policyNumberController.text.toUpperCase(),
        expirationDate: _selectedDate!,
        coverage: _coverageController.text.toUpperCase(),
        lastUpdate: DateTime.now(),
        engineNumber: _engineNumberController.text.toUpperCase(),
        chassisNumber: _chassisNumberController.text.toUpperCase(),
        policyHolderName: _policyHolderNameController.text.toUpperCase(),
        policyFileName: _insurance?.policyFileName,
        policyFileUrl: _insurance?.policyFileUrl,
        carId: widget.carId,
        userId: user.uid,
      );

      if (_isEdit) {
        try {
          await _insuranceService.updateInsurance(insurance, _selectedFile);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Seguro guardado con éxito.')));
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
          await _insuranceService.addInsurance(insurance, _selectedFile);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Seguro añadido con éxito.')));
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error al añadir: $e')));
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    // Define el rango de fechas permitido
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(2000); // Fecha mínima
    final DateTime lastDate = DateTime(2100); // Fecha máxima

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now, // Si ya hay fecha, arranca ahí
      firstDate: firstDate,
      lastDate: lastDate,
      // Opcional: Cambiar el idioma a español si tienes configurada la localización
      // locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // Color del encabezado y selección
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Actualizamos el texto del input visualmente
        _expirationDateController.text = DateFormat(
          'dd/MM/yyyy',
        ).format(_selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? "Editar Seguro" : "Añadir Seguro"),
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
                    controller: _insuranceNameController,
                    decoration: InputDecoration(
                      labelText: "Aseguradora",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre de la aseguradora es obligatorio';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  TextFormField(
                    controller: _policyNumberController,
                    decoration: InputDecoration(
                      labelText: "N° de póliza",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El N° de póliza es obligatorio';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  TextFormField(
                    controller: _expirationDateController,
                    readOnly: true,
                    onTap: () => _pickDate(context),
                    decoration: InputDecoration(
                      labelText: "Fecha de expiración",
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _pickDate(context),
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La fecha de expiración es obligatoria';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  TextFormField(
                    controller: _coverageController,
                    decoration: InputDecoration(
                      labelText: "Tipo de cobertura",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El tipo de cobertura es obligatorio';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  TextFormField(
                    controller: _engineNumberController,
                    decoration: InputDecoration(
                      labelText: "N° de motor",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El N° de motor es obligatorio';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  TextFormField(
                    controller: _chassisNumberController,
                    decoration: InputDecoration(
                      labelText: "N° de chasis",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El N° de chasis es obligatorio';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  TextFormField(
                    controller: _policyHolderNameController,
                    decoration: InputDecoration(
                      labelText: "Titular",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre del titular es obligatorio';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  const Text(
                    "Comprobante de Póliza Digital",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  _buildFilePickerCard(),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : Text(_isEdit ? "Guardar cambios" : "Añadir seguro"),
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

  Widget _buildFilePickerCard() {
    String textToShow;
    IconData iconToShow;
    Color colorToShow;
    Color iconColor;

    // CASO 1: El usuario ACABA de elegir un archivo nuevo (Prioridad Alta)
    if (_selectedFile != null) {
      // Obtenemos solo el nombre del archivo local (ej: "nueva_foto.jpg")
      textToShow = _selectedFile!.name;
      iconToShow = Icons.check_circle;
      colorToShow = Colors.green.shade50; // Verde: "Listo para subir"
      iconColor = Colors.green;
    }
    // CASO 2: Ya existe un archivo guardado en la Base de Datos (Prioridad Media)
    else if (_insurance != null &&
        _insurance!.policyFileName != null &&
        _insurance!.policyFileUrl!.isNotEmpty) {
      // ¡AQUÍ MOSTRAMOS EL NOMBRE GUARDADO!
      textToShow = _insurance!.policyFileName!;
      iconToShow = Icons.cloud_done;
      colorToShow = Colors.blue.shade50; // Azul: "Ya está en la nube"
      iconColor = Colors.blue;
    }
    // CASO 3: No hay nada (Prioridad Baja)
    else {
      textToShow = "Tocar para subir Póliza (PDF o Foto)";
      iconToShow = Icons.upload_file;
      colorToShow = Colors.grey.shade100; // Gris: "Vacío"
      iconColor = Colors.grey;
    }

    return InkWell(
      onTap: _pickFile,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorToShow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: iconColor.withOpacity(0.5), width: 1),
        ),
        child: Row(
          children: [
            Icon(iconToShow, size: 30, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título pequeño para dar contexto
                  if (_selectedFile == null &&
                      _insurance?.policyFileName != null)
                    Text(
                      "Archivo actual:",
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),

                  // El nombre del archivo
                  Text(
                    textToShow,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis, // Pone "..." si es muy largo
                  ),
                ],
              ),
            ),
            // Un lapicito para indicar que se puede cambiar
            const SizedBox(width: 8),
            const Icon(Icons.edit, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

import 'package:caropshibrida/models/insurance_model.dart';
import 'package:caropshibrida/services/auth_service.dart';
import 'package:caropshibrida/services/insurance_service.dart';
import 'package:caropshibrida/utils/extensions.dart';
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
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final user = _authService.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.error_not_logged)));
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.insurance_saved_success)),
          );
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(context.l10n.error_saving(e))));
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        try {
          await _insuranceService.addInsurance(insurance, _selectedFile);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.insurance_added_success)),
          );
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(context.l10n.error_adding(e))));
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
    final DateTime firstDate = DateTime(2000);
    final DateTime lastDate = DateTime(2100);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
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
        title: Text(
          _isEdit
              ? context.l10n.insurance_edit_title
              : context.l10n.insurance_add_title,
        ),
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
                      labelText: context.l10n.insurance_name_label,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.insurance_name_required;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  TextFormField(
                    controller: _policyNumberController,
                    decoration: InputDecoration(
                      labelText: context.l10n.policy_number_label,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.policy_number_required;
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
                      labelText: context.l10n.expiration_date_label,
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _pickDate(context),
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.expiration_date_required;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  TextFormField(
                    controller: _coverageController,
                    decoration: InputDecoration(
                      labelText: context.l10n.coverage_label,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.coverage_required;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  TextFormField(
                    controller: _engineNumberController,
                    decoration: InputDecoration(
                      labelText: context.l10n.engine_number_label,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.engine_number_required;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  TextFormField(
                    controller: _chassisNumberController,
                    decoration: InputDecoration(
                      labelText: context.l10n.chassis_number_label,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.chassis_number_required;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  TextFormField(
                    controller: _policyHolderNameController,
                    decoration: InputDecoration(
                      labelText: context.l10n.policy_holder_label,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.policy_holder_required;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  Text(
                    context.l10n.policy_document_title,
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
                          : Text(
                              _isEdit
                                  ? context.l10n.save_changes_button
                                  : context.l10n.add_insurance,
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
      textToShow = context.l10n.pick_file_hint;
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
                      context.l10n.current_file_label,
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

import 'package:caropshibrida/models/expense_model.dart';
import 'package:caropshibrida/models/expense_type_model.dart';
import 'package:caropshibrida/services/auth_service.dart';
import 'package:caropshibrida/services/expense_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpenseForm extends StatefulWidget {
  final String carId;
  final String carName;
  final Expense? expense;

  const ExpenseForm({
    super.key,
    required this.carId,
    required this.carName,
    this.expense,
  });

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();

  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _expenseTypeController = TextEditingController();

  late final ExpenseService _expenseService;
  late final AuthService _authService;

  Expense? _expense;

  late final String _carId;
  late final String _carName;

  bool _isLoadingTypes = true;

  bool _isLoading = false;
  bool _isEdit = false;

  DateTime? _selectedDate;
  String? _selectedExpenseTypeId;

  List<ExpenseType> _expenseTypeOptions = [];

  Future<void> _loadExpenseTypes() async {
    try {
      final List<ExpenseType> types = await _expenseService.getExpenseTypes();

      if (!mounted) return;

      setState(() {
        _expenseTypeOptions = types;
        _isLoadingTypes = false;
      });
    } catch (e) {
      print("Error cargando tipos: $e");
      if (mounted) {
        setState(() => _isLoadingTypes = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _expenseService = context.read<ExpenseService>();
    _authService = context.read<AuthService>();
    _expense = widget.expense;
    _carId = widget.carId;
    _carName = widget.carName;
    if (_expense != null) {
      loadFields(_expense!);
      setState(() {
        _isEdit = true;
      });
    }

    _loadExpenseTypes();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _expenseTypeController.dispose();
    super.dispose();
  }

  void loadFields(Expense expense) {
    setState(() {
      _selectedDate = expense.date;
      _selectedExpenseTypeId = expense.expenseTypeId;
      _descriptionController.text = expense.description;
      _amountController.text = expense.amount.toString();
      _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(2000);
    final DateTime lastDate = DateTime(2100);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
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
        _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
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

      final double amount = double.parse(_amountController.text);

      Expense expense = Expense(
        id: _expense?.id,
        description: _descriptionController.text.toUpperCase(),
        amount: amount,
        date: _selectedDate!,
        expenseTypeId: _selectedExpenseTypeId!,
        carId: _carId,
        carName: _carName,
        userId: user.uid,
      );

      if (_isEdit) {
        try {
          await _expenseService.updateExpense(expense);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Gasto guardado con éxito.')));
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
          await _expenseService.addExpense(expense);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Gasto añadido con éxito.')));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? "Editar Gasto" : "Añadir Gasto"),
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
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: "Descripción",
                      hintText: "Ej: Combustible",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La descripción del gasto es obligatoria';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: "Monto",
                      hintText: "",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "El monto del gasto es obligatorio";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: () => _pickDate(context),
                    decoration: InputDecoration(
                      labelText: "Fecha del gasto",
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

                  _isLoadingTypes
                      ? const Center(child: CircularProgressIndicator())
                      : DropdownButtonFormField(
                          value: _selectedExpenseTypeId,
                          decoration: InputDecoration(
                            labelText: "Tipo de Gasto",
                            border: OutlineInputBorder(),
                          ),

                          items: _expenseTypeOptions.map((ExpenseType type) {
                            return DropdownMenuItem<String>(
                              value: type.id,
                              child: Text(type.name),
                            );
                          }).toList(),

                          onChanged: (String? newId) {
                            setState(() {
                              _selectedExpenseTypeId = newId;
                            });
                          },

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "El tipo de gasto es obligatorio";
                            }
                          },
                        ),

                  SizedBox(height: 16.0),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : Text(_isEdit ? "Guardar cambios" : "Añadir gasto"),
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

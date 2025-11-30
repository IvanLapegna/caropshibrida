import 'package:caropshibrida/models/car_model.dart';
import 'package:caropshibrida/models/expense_model.dart';
import 'package:caropshibrida/models/expense_type_model.dart';
import 'package:caropshibrida/screens/expense_card.dart';
import 'package:caropshibrida/services/auth_service.dart';
import 'package:caropshibrida/services/car_service.dart';
import 'package:caropshibrida/services/expense_service.dart';
import 'package:caropshibrida/utils/extensions.dart';
import 'package:caropshibrida/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpenseList extends StatefulWidget {
  final String? preselectedCarId;
  final String? preselectedCarName;

  const ExpenseList({
    super.key,
    this.preselectedCarId,
    this.preselectedCarName,
  });

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  late final AuthService _authService;
  late final CarService _carService;
  late final ExpenseService _expenseService;
  String? _userId;
  String? _selectedCarId;
  String? _selectedExpenseTypeId;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  List<Car> _userCars = [];
  List<ExpenseType> _expenseTypes = [];
  late Stream<List<Expense>> _expensesStream;

  Future<void> _loadUserCars() async {
    if (_userId != null) {
      final cars = await _carService.getCarsFromUser(_userId!);
      if (mounted) {
        setState(() {
          _userCars = cars;
        });
      }
    }
  }

  Future<void> _loadExpenseTypes() async {
    final expenseTypes = await _expenseService.getExpenseTypes();

    if (mounted) {
      setState(() {
        _expenseTypes = expenseTypes;
      });
    }
  }

  void _updateStream() {
    if (_userId == null) return;

    _expensesStream = _expenseService.getExpenses(
      _userId!,
      _selectedCarId,
      _selectedExpenseTypeId,
      _selectedStartDate,
      _selectedEndDate?.add(
        const Duration(hours: 23, minutes: 59, seconds: 59),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _authService = context.read<AuthService>();
    _carService = context.read<CarService>();
    _expenseService = context.read<ExpenseService>();
    _userId = _authService.currentUser?.uid;
    _selectedCarId = widget.preselectedCarId;

    _loadUserCars();
    _loadExpenseTypes();

    _updateStream();
  }

  void _pickDateRange() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        DateTime? tempStart = _selectedStartDate;
        DateTime? tempEnd = _selectedEndDate;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(
                context.l10n.filter_by_date_title,
                style: TextStyle(fontSize: 18),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(
                      context.l10n.date_from_label,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    subtitle: Text(
                      tempStart == null
                          ? context.l10n.select_date
                          : DateFormat('dd/MM/yyyy').format(tempStart!),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: tempStart ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate:
                            tempEnd ??
                            DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setStateDialog(() {
                          tempStart = picked;
                          if (tempEnd != null && tempEnd!.isBefore(picked)) {
                            tempEnd = null;
                          }
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 10),

                  ListTile(
                    title: Text(
                      context.l10n.date_to_label,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    subtitle: Text(
                      tempEnd == null
                          ? context.l10n.select_date
                          : DateFormat('dd/MM/yyyy').format(tempEnd!),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(Icons.event, size: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: tempEnd ?? (tempStart ?? DateTime.now()),
                        firstDate: tempStart ?? DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setStateDialog(() => tempEnd = picked);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(context.l10n.cancel),
                ),
                ElevatedButton(
                  onPressed: (tempStart != null || tempEnd != null)
                      ? () {
                          setState(() {
                            _selectedStartDate = tempStart;
                            _selectedEndDate = tempEnd;
                            _updateStream();
                          });
                          Navigator.pop(dialogContext);
                        }
                      : null,
                  child: Text(context.l10n.apply),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showTypeFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.filter_by_type_title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              ..._expenseTypes.map(
                (type) => ListTile(
                  title: Text(type.name),
                  leading: Icon(getIconForType(type.id)),
                  selected: _selectedExpenseTypeId == type.id,
                  selectedColor: Theme.of(context).primaryColor,
                  onTap: () {
                    setState(() {
                      _selectedExpenseTypeId = type.id;
                      _updateStream();
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: Text(context.l10n.view_all),
                leading: const Icon(Icons.clear_all),
                onTap: () {
                  setState(() {
                    _selectedExpenseTypeId = null;
                    _updateStream();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCarFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.filter_by_vehicle_title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              if (_userCars.isEmpty)
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(context.l10n.no_vehicles_registered),
                ),
              ..._userCars.map(
                (car) => ListTile(
                  title: Text(car.toString()),
                  leading: const Icon(Icons.directions_car),
                  selected: _selectedCarId == car.id,
                  selectedColor: Theme.of(context).primaryColor,
                  onTap: () {
                    setState(() {
                      _selectedCarId = car.id;
                      _updateStream();
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: Text(context.l10n.view_all),
                leading: const Icon(Icons.clear_all),
                onTap: () {
                  setState(() {
                    _selectedCarId = null;
                    _updateStream();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _getDateLabel() {
    if (_selectedStartDate == null && _selectedEndDate == null)
      return context.l10n.fechas_label;

    final startStr = _selectedStartDate != null
        ? DateFormat('dd/MM').format(_selectedStartDate!)
        : context.l10n.date_start_short;
    final endStr = _selectedEndDate != null
        ? DateFormat('dd/MM').format(_selectedEndDate!)
        : context.l10n.date_today_label;

    if (_selectedStartDate != null && _selectedEndDate == null) {
      return context.l10n.date_from_label + " " + startStr;
    }
    if (_selectedStartDate == null && _selectedEndDate != null)
      return context.l10n.date_to_label + " " + endStr;

    return "$startStr - $endStr";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.expense_list_title),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            height: 3.0,
            width: 120,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_selectedCarId != null ||
              _selectedExpenseTypeId != null ||
              _selectedStartDate != null ||
              _selectedEndDate != null)
            IconButton(
              icon: const Icon(Icons.filter_alt_off),
              tooltip: context.l10n.clear_filters_tooltip,
              onPressed: () {
                setState(() {
                  _selectedCarId = null;
                  _selectedExpenseTypeId = null;
                  _selectedStartDate = null;
                  _selectedEndDate = null;
                  _updateStream();
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                FilterChip(
                  label: Text(() {
                    if (_selectedCarId == null)
                      return context.l10n.vehicle_label_single;

                    final carInList = _userCars
                        .where((c) => c.id == _selectedCarId)
                        .firstOrNull;

                    if (carInList != null) {
                      return carInList.toString();
                    }

                    if (widget.preselectedCarId == _selectedCarId &&
                        widget.preselectedCarName != null) {
                      return widget.preselectedCarName!;
                    }
                    return context.l10n.vehicle_placeholder;
                  }()),
                  selected: _selectedCarId != null,
                  onSelected: (_) => _showCarFilter(),
                  avatar: const Icon(Icons.directions_car, size: 18),
                ),
                const SizedBox(width: 8),

                FilterChip(
                  label: Text(
                    _selectedExpenseTypeId == null
                        ? context.l10n.type_label
                        : _expenseTypes
                              .firstWhere(
                                (expense) =>
                                    expense.id == _selectedExpenseTypeId,
                              )
                              .name,
                  ),
                  selected: _selectedExpenseTypeId != null,
                  onSelected: (_) => _showTypeFilter(),
                  avatar: const Icon(Icons.monetization_on, size: 18),
                ),
                const SizedBox(width: 8),

                FilterChip(
                  label: Text(_getDateLabel()),
                  selected:
                      _selectedStartDate != null || _selectedEndDate != null,
                  onSelected: (_) => _pickDateRange(),
                  avatar: const Icon(Icons.calendar_today, size: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Expense>>(
              stream: _expensesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error.toString()}"),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      context.l10n.no_expenses_message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                final expenses = snapshot.data ?? [];

                if (expenses.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.filter_alt_off,
                            size: 60,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.l10n.no_expenses_filtered,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenses[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: ExpenseCard(
                            expense: expense,
                            showCarName: true,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

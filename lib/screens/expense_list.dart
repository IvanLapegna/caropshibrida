import 'package:caropshibrida/models/expense_model.dart';
import 'package:caropshibrida/screens/expense_card.dart';
import 'package:caropshibrida/services/auth_service.dart';
import 'package:caropshibrida/services/car_service.dart';
import 'package:caropshibrida/services/expense_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseList extends StatefulWidget {
  const ExpenseList({super.key});

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  late final AuthService _authService;
  late final CarService _carService;
  late final ExpenseService _expenseService;
  String? _userId;

  @override
  void initState() {
    super.initState();

    _authService = context.read<AuthService>();
    _carService = context.read<CarService>();
    _expenseService = context.read<ExpenseService>();
    _userId = _authService.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Gastos'),
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
      ),
      body: StreamBuilder<List<Expense>>(
        stream: _expenseService.getExpenses(_userId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error.toString()}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No tienes gastos.\nVe a la sección 'Mis Vehículos' para añadir uno desde el detalle de tu auto.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final expenses = snapshot.data!;

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
                    child: ExpenseCard(expense: expense, showCarName: true),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

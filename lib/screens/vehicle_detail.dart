import 'package:caropshibrida/models/car_model.dart';
import 'package:caropshibrida/models/expense_model.dart';
import 'package:caropshibrida/models/insurance_model.dart';
import 'package:caropshibrida/screens/expense_card.dart';
import 'package:caropshibrida/services/car_service.dart';
import 'package:caropshibrida/services/expense_service.dart';
import 'package:caropshibrida/services/insurance_service.dart';
import 'package:caropshibrida/src/theme/colors.dart';
import 'package:caropshibrida/utils/extensions.dart';
import 'package:caropshibrida/utils/file_opener.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Este es el Widget principal, equivalente a tu Activity/Fragment host
class CarDetailScreen extends StatefulWidget {
  final String carId;

  const CarDetailScreen({super.key, required this.carId});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  late Stream<Car?> _carStream;
  late final CarService _carService;
  late final InsuranceService _insuranceService;
  late final ExpenseService _expenseService;

  @override
  void initState() {
    super.initState();

    _carService = context.read<CarService>();

    _insuranceService = context.read<InsuranceService>();

    _expenseService = context.read<ExpenseService>();

    _carStream = _carService.getCarById(widget.carId);
  }

  final BoxDecoration _cardDecoration = BoxDecoration(
    color: appColorsLight.cardBackground,
    borderRadius: BorderRadius.circular(8.0),
  );

  final BoxDecoration _chipDecoration = BoxDecoration(
    color: appColorsLight.button,
    borderRadius: BorderRadius.circular(20.0),
  );

  final TextStyle _cardTitleStyle = TextStyle(
    color: appColorsLight.darkerGray,
    fontSize: 16.0,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Car?>(
      stream: _carStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          Future.microtask(() {
            Navigator.of(context).pop();
          });

          return Scaffold(
            body: Center(child: Text(context.l10n.vehicle_deleted_message)),
          );
        }

        final Car car = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "${car.brand} ${car.model}",
              style: const TextStyle(fontWeight: FontWeight.bold),
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildCarImage(car.imageUrl),

                      if (!kIsWeb) _buildActionButtons(car),

                      _buildCarDataCard(car),

                      _buildInsuranceSectionResolve(car),

                      _buildExpensesCard(car),

                      const SizedBox(height: 30.0),
                      Padding(
                        // android:layout_marginHorizontal="30dp"
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              _deleteCar(car);
                            },
                            child: Text(context.l10n.delete_vehicle_button),
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
      },
    );
  }

  Widget _buildCarImage(String? imageUrl) {
    return Padding(
      // Ajusté el padding para que se vea más como una "tarjeta" centrada
      padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
      child: Container(
        // 1. TAMAÑO ESTÁNDAR:
        // Definimos una altura fija. Todas las fotos ocuparán exactamente este espacio.
        height: 250.0,
        width: double.infinity,

        // 2. BORDES REDONDEADOS Y ESTILO:
        decoration: BoxDecoration(
          color: appColorsLight
              .cardBackground, // Color de fondo por si la imagen carga lento
          borderRadius: BorderRadius.circular(20.0), // El radio de la curva
          boxShadow: [
            // Sombra suave para darle profundidad (opcional)
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        // Esto es CRÍTICO: Recorta la imagen para que respete el borde redondeado
        clipBehavior: Clip.antiAlias,

        child: (imageUrl != null && imageUrl.isNotEmpty)
            ? Image.network(
                imageUrl,
                // 3. AJUSTE DE IMAGEN:
                // 'cover': La imagen hace zoom para llenar todo el cuadro. Se ve más estético.
                // 'contain': Muestra la imagen entera, pero puede dejar bandas vacías a los lados.
                fit: BoxFit.contain,

                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        Text(
                          context.l10n.not_available,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              )
            : Image.asset(
                'assets/images/generic_car_icon.png',
                // Para el icono genérico, a veces 'contain' o 'scaleDown' queda mejor
                // para que no se vea pixelado si es pequeño.
                fit: BoxFit.contain,
              ),
      ),
    );
  }

  /// 2. Construye la fila de botones (Estacionar, Recordatorios)
  Widget _buildActionButtons(Car car) {
    return Padding(
      // android:layout_marginHorizontal="30dp" y layout_marginTop="16dp"
      padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
      child: Container(
        // android:background="@drawable/container_border_background"
        decoration: _cardDecoration,
        // android:paddingVertical="8dp"
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          // android:weightSum="2" se logra con Expanded(flex: 1)
          children: [
            _buildTopIconButton(
              icon: Icons.local_parking, // Mapeo de @drawable/parking_icon
              label: context.l10n.park_label, // @string/estacionar
              onPressed: () {
                Navigator.pushNamed(context, '/parking', arguments: car);
              },
            ),
            _buildTopIconButton(
              icon: Icons.notifications, // Mapeo de @drawable/reminder_icon
              label: context.l10n.reminders_label, // @string/recordatorios
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/reminders',
                  arguments: {"carId": car.id, "carName": car.toString()},
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarDataCard(Car car) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: _cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: context.l10n.section_vehicle_data,
              actions: [
                IconButton(
                  icon: Icon(Icons.edit, color: appColorsLight.darkerGray),
                  tooltip: context.l10n.edit_vehicle_tooltip,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/edit-vehicle',
                      arguments: car,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            _buildInfoText(
              "${context.l10n.last_update_label}: ${DateFormat('dd/MM/yyyy').format(car.lastUpdate)}",
            ),
            _buildInfoText(
              "${context.l10n.license_plate_label}: ${car.licensePlate}",
            ),
            _buildInfoText('${context.l10n.brand_label}: ${car.brand}'),
            _buildInfoText('${context.l10n.model_label}: ${car.model}'),
            _buildInfoText('${context.l10n.year_label}: ${car.anio}'),
            _buildInfoText('${context.l10n.engine_label}: ${car.engine}'),
            _buildInfoText(
              '${context.l10n.transmission_label}: ${car.transmission}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsuranceSectionResolve(Car car) {
    return StreamBuilder<Insurance?>(
      stream: _insuranceService.getInsuranceByCarId(car.id!),
      builder: (context, insuranceSnapshot) {
        if (insuranceSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final Insurance? insuranceData = insuranceSnapshot.data;

        return _buildInsuranceCard(car, insuranceData);
      },
    );
  }

  Widget _buildInsuranceCard(Car car, Insurance? insurance) {
    bool hasInsuranceData = insurance != null;

    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: _cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: context.l10n.insurance_section_title,
              actions: [
                if (hasInsuranceData) ...[
                  IconButton(
                    icon: Icon(
                      Icons.description,
                      color: appColorsLight.darkerGray,
                    ),
                    tooltip: context.l10n.view_policy_tooltip,
                    onPressed: () {
                      if (insurance.policyFileUrl != null) {
                        FileOpener.openFile(
                          context,
                          insurance.policyFileUrl!,
                          insurance.policyFileName!,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.l10n.no_file_uploaded),
                          ),
                        );
                        return;
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: appColorsLight.darkerGray),
                    tooltip: context.l10n.edit_insurance_tooltip,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/edit-insurance',
                        arguments: {"carId": car.id, "insurance": insurance},
                      );
                    },
                  ),
                ],
              ],
            ),

            if (hasInsuranceData) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  _buildInfoText(
                    "${context.l10n.last_update_label}: ${DateFormat('dd/MM/yyyy').format(insurance.lastUpdate)}",
                  ),
                  _buildInfoText(
                    "${context.l10n.insurance_name_label}: ${insurance.insuranceName}",
                  ),
                  _buildInfoText(
                    '${context.l10n.policy_number_label}: ${insurance.policyNumber}',
                  ),
                  _buildInfoText(
                    '${context.l10n.expiration_date_label}: ${DateFormat('dd/MM/yyyy').format(insurance.expirationDate)}',
                  ),
                  _buildInfoText(
                    '${context.l10n.coverage_label}: ${insurance.coverage}',
                  ),
                  _buildInfoText(
                    '${context.l10n.engine_number_label}: ${insurance.engineNumber}',
                  ),
                  _buildInfoText(
                    '${context.l10n.chassis_number_label}: ${insurance.chassisNumber}',
                  ),
                  _buildInfoText(
                    '${context.l10n.policy_holder_label}: ${insurance.policyHolderName}',
                  ),
                ],
              ),
            ] else ...[
              _buildAddDataWidget(
                message: context.l10n.add_insurance_message,
                buttonText: context.l10n.add_insurance_button,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/add-insurance',
                    arguments: car.id,
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesCard(Car car) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: _cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: context.l10n.expenses_section_title,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: appColorsLight.darkerGray,
                  ),
                  tooltip: context.l10n.expense_add,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/add-expense',
                      arguments: {"carId": car.id, "carName": car.toString()},
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.list, color: appColorsLight.darkerGray),
                  tooltip: context.l10n.view_expenses_tooltip,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/expenses',
                      arguments: {
                        "preselectedCarId": car.id,
                        "preselectedCarName": car.toString(),
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            StreamBuilder<List<Expense>>(
              stream: _expenseService.getExpensesForCar(car.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final expenses = snapshot.data ?? [];

                if (expenses.isEmpty) {
                  return _buildAddDataWidget(
                    message: context.l10n.no_expenses_registered,
                    buttonText: context.l10n.add_expense_button,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/add-expense',
                        arguments: {"carId": car.id, "carName": car.toString()},
                      );
                    },
                  );
                }

                return Column(
                  children: expenses.map((expense) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: ExpenseCard(expense: expense, showCarName: false),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS DE COMPONENTES REUTILIZABLES ---

  /// Simula el botón con ícono arriba (app:iconGravity="top")
  Widget _buildTopIconButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    // Expanded con flex: 1 reemplaza a layout_weight="1"
    return Expanded(
      flex: 1,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: appColorsLight.darkerGray, // android:textColor
          padding: const EdgeInsets.symmetric(vertical: 8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32.0, // app:iconSize="32dp"
              color: appColorsLight.button, // app:iconTint="@color/button"
            ),
            Text(label),
          ],
        ),
      ),
    );
  }

  /// Construye un header de sección (Chip + Botones)
  /// Reemplaza el ConstraintLayout usado en los headers
  Widget _buildSectionHeader({
    required String title,
    required List<Widget> actions,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // El "Chip" con el título
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          decoration: _chipDecoration,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 14.0),
          ),
        ),
        // Fila para los botones de acción
        Row(children: actions),
      ],
    );
  }

  /// Simula un TextView de info (p.ej. "Marca: Ford")
  Widget _buildInfoText(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
      ), // android:layout_marginTop="8dp"
      child: Text(text, style: _cardTitleStyle),
    );
  }

  Widget _buildAddDataWidget({
    required String message,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: appColorsLight.darkerGray, fontSize: 16.0),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: appColorsLight.button,
              foregroundColor: Colors.white,
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  void _deleteCar(Car car) async {
    try {
      await _carService.deleteCar(car);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.vehicle_created_success)),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.error_creating(e))));
    }
  }
}

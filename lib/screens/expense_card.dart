import 'package:caropshibrida/models/expense_model.dart';
import 'package:caropshibrida/services/expense_service.dart';
import 'package:caropshibrida/src/theme/colors.dart';
import 'package:caropshibrida/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:caropshibrida/l10n/app_localizations.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final bool showCarName;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.showCarName,
  });

  @override
  Widget build(BuildContext context) {
    final double topMargin = showCarName ? 12.0 : 0.0;

    final expenseService = context.read<ExpenseService>();

    return Padding(
      padding: EdgeInsets.only(top: topMargin),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            color: appColorsLight.cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            clipBehavior: Clip.antiAlias,
            elevation: 4,
            margin: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: getColorForType(
                            expense.expenseTypeId,
                          ).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: getColorForType(
                              expense.expenseTypeId,
                            ).withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          getIconForType(expense.expenseTypeId),
                          color: getColorForType(expense.expenseTypeId),
                          size: 24,
                        ),
                      ),

                      const SizedBox(width: 16.0),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              expense.description,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6.0),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 12,
                                  color: Colors.white54,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(expense.date),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(height: 1, color: Colors.white.withOpacity(0.15)),

                Container(
                  color: Colors.black.withOpacity(0.2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 6.0,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "\$ ${expense.amount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.lightGreenAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/edit-expense',
                            arguments: {
                              "carId": expense.carId,
                              "carName": expense.carName,
                              "expense": expense,
                            },
                          );
                        },
                        constraints: const BoxConstraints(),
                        tooltip: AppLocalizations.of(context)!.editar,
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        onPressed: () => _handleDelete(context, expenseService),
                        constraints: const BoxConstraints(),
                        tooltip: AppLocalizations.of(context)!.eliminar,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (showCarName)
            Positioned(
              top: -12,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  expense.carName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleDelete(
    BuildContext parentContext,
    ExpenseService expenseService,
  ) {
    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        bool isDeleting = false;

        return StatefulBuilder(
          builder: (innerContext, setState) {
            final loc = AppLocalizations.of(dialogContext)!;

            return AlertDialog(
              title: Text(loc.eliminarGastoTitle),
              content: Text(loc.confirmDeleteExpense(expense.description)),
              actions: [
                if (isDeleting)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else ...[
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text(loc.cancelar),
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        isDeleting = true;
                      });

                      try {
                        await expenseService.deleteExpense(expense.id!);

                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);

                          if (parentContext.mounted) {
                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(
                                    parentContext,
                                  )!.gastoEliminado,
                                ),
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        if (dialogContext.mounted) {
                          setState(() {
                            isDeleting = false;
                          });
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(
                                  dialogContext,
                                )!.errorEliminar(e.toString()),
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: Text(
                      AppLocalizations.of(dialogContext)!.eliminar,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}

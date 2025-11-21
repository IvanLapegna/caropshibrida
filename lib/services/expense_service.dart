import 'package:caropshibrida/models/expense_model.dart';
import 'package:caropshibrida/models/expense_type_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseService {
  final CollectionReference _expensesCollection = FirebaseFirestore.instance
      .collection("expenses");

  final CollectionReference _expenseTypesCollection = FirebaseFirestore.instance
      .collection("expenseTypes");

  Future<void> addExpense(Expense expense) async {
    try {
      DocumentReference docRef = _expensesCollection.doc();

      expense.id = docRef.id;

      await docRef.set(expense.toMap());
    } catch (e) {
      print("Error al agregar el gasto: $e");
    }
  }

  Stream<List<Expense>> getExpenses(
    String userId,
    String? carId,
    String? expenseTypeId,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    Query query = _expensesCollection.where("userId", isEqualTo: userId);

    if (carId != null) {
      query = query.where("carId", isEqualTo: carId);
    }

    if (expenseTypeId != null) {
      query = query.where("expenseTypeId", isEqualTo: expenseTypeId);
    }

    if (startDate != null) {
      query = query.where("date", isGreaterThanOrEqualTo: startDate);
    }

    if (endDate != null) {
      query = query.where("date", isLessThanOrEqualTo: endDate);
    }

    query = query.orderBy('date', descending: true);

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Expense.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Stream<List<Expense>> getExpensesForCar(String carId, {int limit = 3}) {
    return _expensesCollection
        .where("carId", isEqualTo: carId)
        .orderBy("date", descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Expense.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();
        });
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      await _expensesCollection.doc(expense.id).update(expense.toMap());
    } catch (e) {
      print("Error al actualizar el gasto: $e");
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      await _expensesCollection.doc(expenseId).delete();
    } catch (e) {
      print("Error al eliminar el gasto: $e");
    }
  }

  Future<List<ExpenseType>> getExpenseTypes() async {
    final snapshot = await _expenseTypesCollection.get();

    return snapshot.docs.map((doc) {
      return ExpenseType.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}

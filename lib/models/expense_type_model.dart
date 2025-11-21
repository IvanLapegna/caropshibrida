class ExpenseType {
  final String id;
  final String name;

  ExpenseType({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {"name": name};
  }

  factory ExpenseType.fromMap(Map<String, dynamic> map, String documentId) {
    return ExpenseType(id: documentId, name: map["name"] ?? "");
  }
}

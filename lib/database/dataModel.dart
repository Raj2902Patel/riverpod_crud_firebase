class DataBase {
  final String id;
  final String empName;
  final String empNumber;

  DataBase({required this.id, required this.empName, required this.empNumber});

  factory DataBase.fromMap(Map<String, dynamic> map, String documentId) {
    return DataBase(
      id: documentId,
      empName: map['empName'],
      empNumber: map['empNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'empName': empName,
      'empNumber': empNumber,
    };
  }
}

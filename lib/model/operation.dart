import 'package:sqflite_live/types/operation.dart';

class DatabaseOperation {
  late final OperationType type;
  late final Map<String, dynamic> data;
  DatabaseOperation({
    required this.type,
    required this.data,
  });
}

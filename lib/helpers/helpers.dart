import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class SQLFliteLiveHelpers {

  String get currentTimestamp => DateTime.now().toUtc().toIso8601String();

  Future<String> generatePath(String dbName) async => p.join(await getDatabasesPath(), "$dbName.db");

}
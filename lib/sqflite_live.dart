library sqflite_live;

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class SqfliteLive {
  late final Database _database;

  Future<Database> open(String dbName, String createSql, {int version = 1, bool readOnly = false, bool newInstance = false}) async {
    _database = await openDatabase(
      p.join(await getDatabasesPath(), "$dbName.db"),
      version: version,
      readOnly: readOnly,
      singleInstance: !newInstance,
      onCreate: (Database db, int version) => db.execute(createSql),
    );
    return _database;
  }

  void close() async {
    await _database.close();
  }

  void delete(String dbName) async {
    await deleteDatabase(p.join(await getDatabasesPath(), "$dbName.db"));
  }
}

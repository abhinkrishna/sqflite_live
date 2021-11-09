library sqflite_live;

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_live/model/pagination.dart';

class SqfliteLive {
  // Signleton
  static SqfliteLive? _instance;
  SqfliteLive._();
  static SqfliteLive get instance => _instance ??= SqfliteLive._();

  // Declarations
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

  SQLPagination makeSQLPagination(page, limit) => SQLPagination(page, limit);

  get db => _database;

  Future<List<Map<String, Object?>>> rawQuery(raw) async => await this._database.rawQuery(raw);

  Future<int> insert(tableName, values, {ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.rollback}) async => await this._database.insert(tableName, {...values, 'created_at': this.currentTime, 'updated_at': this.currentTime}, conflictAlgorithm: conflictAlgorithm);

  Future<int> update(tableName, values, {String? where, List? whereArgs, ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.rollback}) async => await this._database.update(tableName, {...values, 'updated_at': this.currentTime}, where: where, whereArgs: whereArgs, conflictAlgorithm: conflictAlgorithm);

  Future<int> updateWithId(tableName, values, id) async => await this._database.update(tableName, {...values, 'updated_at': this.currentTime}, where: '"id" = ?', whereArgs: ['$id']);

  Future<List<Map<String, Object?>>> readMany(tableName, {List<String>? columns, String? where, List? whereArgs, String? groupBy, String? having, String? orderBy, SQLPagination? pagination, bool? isDistinct}) async => await this._database.query(tableName, columns: columns, where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy, limit: pagination?.limit, offset: pagination?.offset, distinct: isDistinct);

  Future<Map<String, Object?>?> readOne(tableName, String where, List whereArgs, {String? orderBy}) async {
    List result = await this._database.query(tableName, where: where, whereArgs: whereArgs, orderBy: orderBy, limit: 1);
    return (result.length > 0 && result[0] != null) ? result[0] : null;
  }

  String get currentTime => DateTime.now().toUtc().toIso8601String();

  void close() async {
    await _database.close();
  }

  void delete(String dbName) async {
    await deleteDatabase(p.join(await getDatabasesPath(), "$dbName.db"));
  }
}

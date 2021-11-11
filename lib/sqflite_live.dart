library sqflite_live;

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_live/helpers/helpers.dart';
import 'package:sqflite_live/model/pagination.dart';

class SqfliteLive {
  // Declarations
  late final Database _database;

  late final SQLFliteLiveHelpers _helpers;

  // Constructor
  SqfliteLive(String dbName, {required List<String> createTableQueries, int version = 1, bool readOnly = false, bool newInstance = false}) {
    _helpers = SQLFliteLiveHelpers();
    _init(dbName, createTableQueries, version, readOnly, newInstance);
  }

  Future<Database> _init(String dbName, List<String> createTableQueries, int version, bool readOnly, bool newInstance) async {
    _database = await openDatabase(
      await _helpers.generatePath(dbName),
      version: version,
      readOnly: readOnly,
      singleInstance: !newInstance,
      onCreate: (Database db, int version) {
        for (var query in createTableQueries) db.execute(query);
      },
    );
    return _database;
  }

  SQLPagination makeSQLPagination(page, limit) => SQLPagination(page, limit);

  get db => _database;

  Future<List<Map<String, Object?>>> rawQuery(raw) async => await this._database.rawQuery(raw);

  Future<int> insert(tableName, values, {ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.rollback}) async => await this._database.insert(tableName, {...values, 'created_at': this._helpers.currentTimestamp, 'updated_at': this._helpers.currentTimestamp}, conflictAlgorithm: conflictAlgorithm);

  Future<int> update(tableName, values, {String? where, List? whereArgs, ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.rollback}) async => await this._database.update(tableName, {...values, 'updated_at': this._helpers.currentTimestamp}, where: where, whereArgs: whereArgs, conflictAlgorithm: conflictAlgorithm);

  Future<int> updateWithId(tableName, values, id) async => await this._database.update(tableName, {...values, 'updated_at': this._helpers.currentTimestamp}, where: '"id" = ?', whereArgs: ['$id']);

  Future<List<Map<String, Object?>>> readMany(tableName, {List<String>? columns, String? where, List? whereArgs, String? groupBy, String? having, String? orderBy, SQLPagination? pagination, bool? isDistinct}) async => await this._database.query(tableName, columns: columns, where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy, limit: pagination?.limit, offset: pagination?.offset, distinct: isDistinct);

  Future<Map<String, Object?>?> readOne(tableName, String where, List whereArgs, {String? orderBy}) async {
    List result = await this._database.query(tableName, where: where, whereArgs: whereArgs, orderBy: orderBy, limit: 1);
    return (result.length > 0 && result[0] != null) ? result[0] : null;
  }

  void close() async {
    await _database.close();
  }

  void delete(String dbName) async {
    await deleteDatabase(p.join(await getDatabasesPath(), "$dbName.db"));
  }
}

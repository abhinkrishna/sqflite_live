import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_live/sqflite_live.dart';

void main() {
  test('try opening database ', () async {
    SqfliteLive sqfliteLive = SqfliteLive('test_database', createTableQueries: ['CREATE TABLE ( test id INTEGER PRIMARY KEY AUTOINCREMENT )']);
    var db = sqfliteLive.db;
    expect(db.runtimeType, Database);
    expect(db.path.runtimeType, String);
    expect(db.insert("test_database", {}), 1);
  });
}

import 'dart:convert';

import 'package:sqflite_live/types/datatype.dart';

class ColumnTypeConvert {

  static ColumnTypeConvert get instance => ColumnTypeConvert();

  String doubleToString(double value) => '$value';

  double stringToDouble(String value) => double.parse(value);

  int boolToInteger(bool value) => value ? 1 : 0;

  bool integerToBool(int value) => (value == 1) ? true : false;

  Map<dynamic, dynamic> stringToMap(String value) => jsonDecode(value);

  String mapToString(Map<dynamic, dynamic> value) => jsonEncode(value);

  String listToString(List value) => jsonEncode(value);

  List stringToList(String value) => jsonDecode(value);

  static toDBValue(var value) {
    return (value.runtimeType == int) ? value
    : (value.runtimeType == String) ? value
    : (value.runtimeType == bool) ? ColumnTypeConvert.instance.boolToInteger(value)
    : (value.runtimeType == double) ? ColumnTypeConvert.instance.doubleToString(value)
    : (value.runtimeType == Map) ? ColumnTypeConvert.instance.mapToString(value)
    : (value.runtimeType == List) ? ColumnTypeConvert.instance.listToString(value)
    : value;
  }

  static fromDBValue(var value, ColumnType type) {
    return (ColumnType.boolean == type) ? ColumnTypeConvert.instance.integerToBool(value)
    : (ColumnType.double == type) ? ColumnTypeConvert.instance.stringToDouble(value)
    : (ColumnType.integer == type) ? value
    : (ColumnType.json == type) ? ColumnTypeConvert.instance.stringToMap(value)
    : (ColumnType.list == type) ? ColumnTypeConvert.instance.stringToList(value)
    : (ColumnType.text == type) ? ((value.runtimeType == String) ? value : '$value')
    : value;
  }

}

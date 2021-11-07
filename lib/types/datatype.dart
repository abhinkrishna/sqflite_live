enum ColumnType {
  // Support for integer type
  integer,
  // Support for textual data
  text,
  // Support for boolean [true, false]. SQLite doesn't have
  // support for boolean type but booleans values are converted
  // into integers true -> 1 ; false -> 0
  boolean,
  // Support for json type. SQLite doesn't have support for json
  // Json is stored as string after stringifying a json with jsonEncode()
  json,
  // Support for list type. SQLite doesn't have support for list
  // List is stored as string after stringifying with jsonEncode()
  list,
  // Support for double type. SQLite doesn't have support for double
  // double is stored as string and parsed back to double 
  double,
}

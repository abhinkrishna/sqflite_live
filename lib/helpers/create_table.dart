class TableCreateQuery {
  Map<String, dynamic> _map = {'columns': []};

  TableCreateQuery table(String name) {
    _map['create'] = 'CREATE TABLE $name';
    return this;
  }

  TableCreateQuery primaryColumn(String columnNname, {bool autoIncrement = true, String type = 'INTEGER'}) {
    _map['primary'] = ' $columnNname $type PRIMARY KEY${autoIncrement ? ' AUTOINCREMENT' : ''}';
    return this;
  }

  TableCreateQuery andColumn(String columnNname, {String type = 'TEXT', String extra = '', var defaultValue}) {
    (_map['columns'] as List).add(' $columnNname $type $extra,');
    return this;
  }

  String build() {
    return ''' 
    ${_map['create']} (
      ${_map['primary']},
      ${(_map['columns'] as List).reduce((value, element) => value + element)}
      created_at TEXT,
      updated_at TEXT
    )
    '''
        .replaceAll('  ', '');
  }
}

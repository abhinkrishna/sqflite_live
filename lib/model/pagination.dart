
class SQLPagination {
  late final int limit;
  late final int offset;
  SQLPagination(int page, int limit) {
    this.limit = limit;
    this.offset = (limit * (page != 0 ? (page - 1) : 0));
  }
}

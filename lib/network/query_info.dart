class QueryInfo {

  String search;
  int order;
  int filter;
  int offset;

  QueryInfo ({this.search, this.order, this.filter, this.offset = 0});

  bool get hasSearch {
    if (search != null) {
      return search.isNotEmpty;
    }
    return false;
  }
}

class ParserWithQueryInfo {
  QueryInfo queryInfo;

  bool isQueryInfoEmpty() {
    if (queryInfo == null) {
      return true;
    } else {
      if (queryInfo.offset == 0 && !queryInfo.hasSearch) {
        return true;
      }
    }
    return false;
  }
}
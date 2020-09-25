abstract class RequestParams {

  String queryParam(dynamic value) {
    if (value is String) {
      return value ?? "";
    } else {
      if (value != null) {
        return value.toString();
      }
    }
    return "";
  }

  String listQueryParam(List values) {
    if (values == null)
      return "";
    return values.map((e) => e.toString()).join(
        ","
    );
  }

  Map<String, String> get queryMap;
}
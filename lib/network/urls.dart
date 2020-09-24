import 'package:schoolmi/network/params/abstract/base.dart';

enum HttpMethod {
  post,
  get
}

class Headers {
  static const String idToken = "X-Id-Token";
  static const String contentType = "Content-Type";
  static const String mediaTypeJson = "application/json";
}

class Urls {

  static const String baseUrl = "https://api-server-v2-dot-schoolmi-4c5ac.ew.r.appspot.com";

  static String urlWithQueryParams(String url, Map<String, String> queryMap) {
    Uri oldUri = Uri.parse(url);
    queryMap.addAll(oldUri.queryParameters);
    queryMap.removeWhere((String key, String value) {
      return value == null || value == "";
    });
    Uri newUri = Uri.https(oldUri.authority, oldUri.path, queryMap);
    return newUri.toString();
  }

  static String urlForPath({ String path, RequestParams params }) {
    String url = "$baseUrl/$path";
    if (params != null) {
        return urlWithQueryParams(url, params.queryMap);
    }
    return url;
  }




}
import 'package:schoolmi/network/requests/abstract/base.dart';
import 'package:http/http.dart' as http;
import 'package:schoolmi/network/urls.dart';

class DummyTokenRequest extends Request {

  Future<String> getIdToken() async {
    var response = await http.get(Urls.urlForPath(path: "idtoken"));
    var rootMap = jsonObjectResponse(response);
    return rootMap["token"];
  }

}
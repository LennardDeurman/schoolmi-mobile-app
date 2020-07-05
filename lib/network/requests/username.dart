import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schoolmi/network/requests/abstract/base.dart';
import 'package:schoolmi/network/routes/global.dart';
import 'package:schoolmi/network/keys.dart';

class UsernameRequest extends Request {

  Future<bool> usernameValid(String username) {
    Completer<bool> completer = new Completer();
    Map<String, dynamic> dictionary = {
      Keys().username: username
    };

    executeJsonRequest(GlobalRoute().usernameCheck, completer, (http.Response response) {
      final body = json.decode(response.body)[Keys().object];
      bool valid = body[Keys().valid];
      completer.complete(valid);
    }, postDictionary: dictionary);
    return completer.future;
  }

}
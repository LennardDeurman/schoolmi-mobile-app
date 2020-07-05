import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:schoolmi/network/requests/abstract/base.dart';
import 'package:schoolmi/network/routes/global.dart';
import 'package:schoolmi/network/keys.dart';

class DeviceRequest extends Request {

  Future bindDevice(String registrationToken) {
    Completer completer = new Completer();
    Map<String, dynamic> dictionary = {
      Keys().registrationToken: registrationToken
    };

    executeJsonRequest(GlobalRoute().devices, completer, (http.Response response) {
      completer.complete();
    }, postDictionary: dictionary);
    return completer.future;
  }

}
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schoolmi/extensions/exceptions.dart';
import 'package:schoolmi/network/auth/provider.dart';
import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/network/urls.dart';

class Request {

  void executeJsonRequest(
      String url, Completer completer,
      Function(http.Response response) handleSuccessAction,
      { postDictionary, HttpMethod httpMethod }
      ) async {

    if (httpMethod == null) {
      httpMethod = postDictionary != null ? HttpMethod.post : HttpMethod.get;
    }

    Map<String, String> headers = {
      Headers.contentType: Headers.mediaTypeJson,
      Headers.idToken: await AuthorizationProvider.getIdToken(),
    };

    var action;
    if (httpMethod == HttpMethod.get) {
      action = http.get(url, headers: headers);
    } else if (httpMethod == HttpMethod.post) {
      action = http.post(url, headers: headers, body: postDictionary != null ? json.encode(postDictionary) : null);
    }

    action.then((http.Response response) {
      if (response != null) {
        if (response.statusCode >= 400) {
          throw InvalidOperationException("HTTP exception");
        }
      }
      handleSuccessAction(response);
    }).catchError((e) {
      completer.completeError(e);
    });
  }

  jsonObjectResponse(http.Response httpResponse) {
    return json.decode(httpResponse.body)[Keys().object];
  }

}
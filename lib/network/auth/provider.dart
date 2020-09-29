import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class AuthorizationProvider {

  static String dummyToken;

  static Future<String> getIdToken() async {
    if (dummyToken != null) {
      return dummyToken;
    }

    Completer<String> completer = Completer();


    try {
      var currentUser = await FirebaseAuth.instance.currentUser();
      var token = await currentUser.getIdToken();
      completer.complete(token.token);
    } catch (e) {
      completer.complete(null);
    }


    return completer.future;
  }

  static Future<String> getMyUid() async {
    String uuid = (await FirebaseAuth.instance.currentUser()).uid;
    return uuid;
  }



}

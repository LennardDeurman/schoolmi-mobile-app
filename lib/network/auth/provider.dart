import 'package:firebase_auth/firebase_auth.dart';

class AuthorizationProvider {

  static String dummyToken;

  static Future<String> getIdToken() async {
    if (dummyToken != null) {
      return dummyToken;
    }

    String firebaseToken = await (await FirebaseAuth.instance.currentUser()).getIdToken();
    return firebaseToken;
  }

  static Future<String> getMyUid() async {
    String uuid = (await FirebaseAuth.instance.currentUser()).uid;
    return uuid;
  }



}

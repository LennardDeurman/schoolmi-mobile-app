import 'dart:async';
class FutureUtils {


  static Future<T> safeLoad<T>(Future<T> futureToLoad) {
    Completer<T> completer = Completer();
    futureToLoad.then((e) {
      completer.complete(e);
    }).catchError((e) {
      completer.complete(null);
    });
    return completer.future;
  }


}
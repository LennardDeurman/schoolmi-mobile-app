import 'dart:async';
class FutureUtils {


  static Future<T> safeLoad<T>(Future<T> futureToLoad) async {
    Completer<T> completer = Completer();

    try {
      var value = await futureToLoad;
      completer.complete(value);
    } catch (e) {
      completer.complete(null);
    }

    return completer.future;
  }


}
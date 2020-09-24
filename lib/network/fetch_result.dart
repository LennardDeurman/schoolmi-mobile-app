import 'package:schoolmi/extensions/dates.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/network/fetch_result.dart';
import 'package:schoolmi/network/models/abstract/base.dart';

class CombinedResult<T extends ParsableObject> {

  FetchResult<T> offlineResult;
  FetchResult<T> onlineResult;

  CombinedResult ( { this.offlineResult, this.onlineResult } );

  FetchResult<T> get result {
    if (onlineResult != null)
      return onlineResult;
    return offlineResult;
  }

  bool get isFetchedOnline {
    return onlineResult != null;
  }

}

class FetchResult<T extends ParsableObject> {

  DateTime dateTime = DateTime.now();

  List<T> objects = [];

  bool retrievedOnline = true;

  FetchResult (this.objects);

  FetchResult.fromCacheDictionary(Map<String, dynamic> dictionary, { T Function(Map<String, dynamic> map) toObject}) {
    var results = dictionary[Keys().results];
    if (results != null) {
      List resultList = results;
      objects = resultList.map((dictionary) {
        return toObject(dictionary);
      }).toList();
    }
    dateTime = Dates.parse(dictionary[Keys().dateModified]);
    retrievedOnline = false;
  }

  void insertNew(T baseObject, { int index = 0 }) {
    objects.insert(index, baseObject);
  }

  void appendResult(FetchResult<T> result) {
    retrievedOnline = result.retrievedOnline;
    dateTime = DateTime.now();
    objects.addAll(result.objects);
  }

  T get object {
    if (objects.length == 0) {
      return null;
    }
    return objects.first;
  }
}

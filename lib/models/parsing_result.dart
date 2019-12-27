import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/extensions/dates.dart';
import 'package:flutter/foundation.dart';

class ParsingResult {

  DateTime dateTime = DateTime.now();

  List<BaseObject> objects = [];

  bool retrievedOnline = true;

  ParsingResult (this.objects);

  ParsingResult.fromCacheDictionary(Map<String, dynamic> dictionary, { @required ParseObjectCallback toObject}) {
      var results = dictionary[Keys.results];
      if (results != null) {
        List resultList = results;
        objects = resultList.map((dictionary) {
          return toObject(dictionary);
        }).toList();
      }
      dateTime = Dates.parse(dictionary[Keys.dateModified]);
      retrievedOnline = false;
  }

  void add(BaseObject baseObject) {
    objects.insert(0, baseObject);
  }

  void appendResult(ParsingResult result) {
    retrievedOnline = result.retrievedOnline;
    dateTime = DateTime.now();
    objects.addAll(result.objects);
  }

  BaseObject get object {
    if (objects.length == 0) {
      return null;
    }
    return objects.first;
  }
}

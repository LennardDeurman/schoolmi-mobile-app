import 'package:flutter/foundation.dart';
import 'package:schoolmi/models/base_object.dart';

abstract class ParsableObject {

  void parse(Map<String, dynamic> dictionary);

  static List<BaseObject> parseObjectsList(Map<String, dynamic> dictionary, String key, {@required ParseObjectCallback toObject}) {
    var dictionaryValuesList = dictionary[key];
    if (dictionaryValuesList != null) {
      List<BaseObject> baseObjects = List<BaseObject>();
      for (Map<String, dynamic> dictionaryValue in dictionaryValuesList) {
        BaseObject baseObject = toObject(dictionaryValue);
        baseObject.parse(dictionaryValue);
        baseObjects.add(baseObject);
      }
      return baseObjects;
    }
    return [];
  }

  static bool parseBool (dynamic value) {
    if (value is bool) {
      return value;
    }
    return value == 1;
  }

  Map<String, dynamic> toDictionary();

}
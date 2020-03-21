import 'package:flutter/foundation.dart';
import 'package:schoolmi/models/base_object.dart';

abstract class ParsableObject {

  void parse(Map<String, dynamic> dictionary);

  static List<T> parseObjectsList<T extends BaseObject>(Map<String, dynamic> dictionary, String key, {@required ParseObjectCallback toObject}) {
    var dictionaryValuesList = dictionary[key];
    if (dictionaryValuesList != null) {
      List<T> baseObjects = List<T>();
      for (Map<String, dynamic> dictionaryValue in dictionaryValuesList) {
        T baseObject = toObject(dictionaryValue);
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
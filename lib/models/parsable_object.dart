import 'package:flutter/foundation.dart';
import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/extensions/dates.dart';

typedef ParseObjectCallback = ParsableObject Function(Map dictionary);

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

  static int parseIntOrZero(dynamic value) {
    return value ?? 0;
  }

  static DateTime parseDate(dynamic value) {
    return Dates.parse(value);
  }

  static Map<String, dynamic> tryGetDict(ParsableObject object) {
    if (object != null) {
      return object.toDictionary();
    }
    return null;
  }

  Map<String, dynamic> toDictionary();

}
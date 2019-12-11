import 'package:schoolmi/models/base_object.dart';
abstract class ParsableObject {

  void parse(Map<String, dynamic> dictionary);

  static List parseObjectsList(Map<String, dynamic> dictionary, String key) {
    var dictionaryValuesList = dictionary[key];
    if (dictionaryValuesList != null) {
      List<BaseObject> baseObjects = List<BaseObject>();
      for (Map<String, dynamic> dictionaryValue in dictionaryValuesList) {
        BaseObject baseObject = BaseObject(dictionaryValue);
        baseObject.parse(dictionaryValue);
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
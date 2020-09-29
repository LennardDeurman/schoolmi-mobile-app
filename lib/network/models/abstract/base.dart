import 'package:schoolmi/extensions/dates.dart';
import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/network/models/extensions/object_with_default_props.dart';



abstract class ParsableObject {


  void parse(Map<String, dynamic> dictionary);

  static List<T> parseObjectsList<T extends ParsableObject>(Map<String, dynamic> dictionary, String key, {ParsableObject objectCreator (Map<String, dynamic> map)}) {
    var dictionaryValuesList = dictionary[key];
    if (dictionaryValuesList != null) {
      List<T> baseObjects = List<T>();
      for (Map<String, dynamic> dictionaryValue in dictionaryValuesList) {
        T baseObject = objectCreator(dictionaryValue);
        baseObject.parse(dictionaryValue);
        baseObjects.add(baseObject);
      }
      return baseObjects;
    }
    return [];
  }



  static dynamic parseObject (Map<String, dynamic> value, { ParsableObject objectCreator (Map<String, dynamic> map) } ) {
    if (value != null) {
      return objectCreator(value);
    }
    return null;
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

  static Map<String, dynamic> dictOrFirst(value) {
    if (value is List) {
      if (value.length > 0)
        return value.first;
    } else if (value is Map) {
      return value;
    }
    return null;
  }

  Map<String, dynamic> toDictionary();

}

abstract class BaseObject with ParsableObject, ObjectWithDefaultProps  {

  int id;

  final Map<String, dynamic> dictionary;



  BaseObject (this.dictionary)  {
    parse(this.dictionary);
  }

  @override
  void parse(Map<String, dynamic> dictionary) {
    parseDefaultProps(dictionary);
    this.id = dictionary[Keys().id];
  }

  @override
  bool operator ==(other) {
    if (other is BaseObject) {
      return other.id == this.id && other.id != null;
    }
    return false;
  }

  @override
  Map<String, dynamic> toDictionary() {
    return {
      Keys().deleted: isDeleted,
      Keys().id: id,
      Keys().dateAdded: Dates.format(dateAdded),
      Keys().dateModified: Dates.format(dateModified)
    };
  }



}
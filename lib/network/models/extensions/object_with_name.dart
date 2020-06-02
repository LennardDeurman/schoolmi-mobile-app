import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/network/models/parsable_object.dart';

class ObjectWithName {

  String name;

  void parseNameInfo(Map<String, dynamic> dictionary) {
    name = dictionary[Keys().name];
  }

  Map<String, dynamic> nameDictionary() {
    return {
      Keys().name: name
    };
  }

}
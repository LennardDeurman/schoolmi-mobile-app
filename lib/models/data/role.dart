import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/models/data/extensions/object_with_colorindex.dart';

class Role extends BaseObject with ObjectWithColorIndex {

  String name;

  Role (Map<String, dynamic> dictionary) : super(dictionary);


  Role.create({ String name }) : super({
    Keys.name: name
  });

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    id = dictionary[Keys.roleId];
    name = dictionary[Keys.name] ?? dictionary[Keys.roleName];
    parseColorIndex(dictionary);
  }

  @override
  bool operator ==(other) {
    if (other is Role) {
      return other.name == this.name && other.name != null;
    }
    return false;
  }

  @override
  Map<String, dynamic> toDictionary() {
    var dictionary = super.toDictionary();
    dictionary[Keys.roleId] = id;
    dictionary[Keys.name] = name;
    return dictionary;
  }

}
import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/data/extensions/object_with_colorindex.dart';

class Tag extends BaseObject with ObjectWithColorIndex {

  String name;

  Tag (Map<String, dynamic> dictionary) : super(dictionary);

  Tag.create({ this.name }) : super(null);

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    parseColorIndex(dictionary);
    id = dictionary[Keys.id] ?? dictionary[Keys.tagId]; //Unfortunately required due to server issues
    name = dictionary[Keys.name] ?? dictionary[Keys.tagName];
  }

}
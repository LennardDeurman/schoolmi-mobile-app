import 'package:schoolmi/models/parsable_object.dart';
import 'package:schoolmi/models/data/tag.dart';
import 'package:schoolmi/constants/keys.dart';

class ObjectWithTags {

  List<Tag> tags;

  void parseTags(Map<String, dynamic> dictionary) {
    tags = ParsableObject.parseObjectsList(dictionary, Keys.tags, toObject: (Map dictionary) {
      return Tag(dictionary);
    });
  }

  Map<String, dynamic> tagsDictionary() {
    return {
      Keys.tags: tags.map((Tag tag) {
        return tag.toDictionary();
      }).toList()
    };
  }
}
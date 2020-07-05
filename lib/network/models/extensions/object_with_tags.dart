import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/models/tag.dart';
import 'package:schoolmi/network/keys.dart';

class ObjectWithTags {

  List<ContentTag> contentTags;

  void parseTags(Map<String, dynamic> dictionary) {
    contentTags = ParsableObject.parseObjectsList(dictionary, Keys().tags, objectCreator: (Map dict) {
      return ContentTag(dict);
    });
  }

  Map<String, dynamic> tagsDictionary() {
    return {
      Keys().tags: contentTags.map((e) => e.toDictionary()).toList()
    };
  }

}
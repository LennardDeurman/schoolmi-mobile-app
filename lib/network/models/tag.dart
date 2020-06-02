import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/models/data/extensions/object_with_color.dart';
import 'package:schoolmi/models/data/extensions/object_with_name.dart';
import 'package:schoolmi/models/data/extensions/object_with_default_props.dart';
import 'package:schoolmi/models/data/linkages/channel_linked_object.dart';
import 'package:schoolmi/models/data/linkages/profile_linked_object.dart';
import 'package:schoolmi/network/models/parsable_object.dart';

class Tag extends BaseObject with ObjectWithColor, ObjectWithName, ChannelLinkedObject, ProfileLinkedObject {

  String name;

  Tag (Map<String, dynamic> dictionary) : super(dictionary);

  Tag.create({ String name }) : super({Keys().name: name});

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    parseColorInfo(dictionary);
    parseNameInfo(dictionary);
    parseChannelLink(dictionary);
    parseProfileLink(dictionary);
  }

  @override
  Map<String, dynamic> toDictionary() {
    var dictionary = super.toDictionary();
    dictionary.addAll(nameDictionary());
    dictionary.addAll(colorInfoDictionary());
    dictionary.addAll(channelLinkDictionary());
    dictionary.addAll(profileLinkDictionary());
    return dictionary;
  }

  @override
  bool operator ==(other) {
    if (other is Tag) {
      return other.name == this.name && other.name != null;
    }
    return false;
  }
}

class ContentTag extends ParsableObject with ObjectWithDefaultProps {

  Tag tag;
  int tagId;

  ContentTag (Map<String, dynamic> dictionary) {
    parse(dictionary);
  }

  @override
  void parse(Map<String, dynamic> dictionary) {
    parseDefaultProps(dictionary);
    tagId = dictionary[Keys().tagId];
    Map tagDictionary = dictionary[Keys().tag];
    if (tagDictionary != null) {
      tag = Tag(tagDictionary);
    }
  }

  @override
  Map<String, dynamic> toDictionary() {
    throw UnimplementedError();
  }

}

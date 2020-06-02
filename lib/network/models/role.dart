import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/models/data/extensions/object_with_color.dart';
import 'package:schoolmi/models/data/extensions/object_with_name.dart';
import 'package:schoolmi/models/data/linkages/profile_linked_object.dart';
import 'package:schoolmi/models/data/linkages/channel_linked_object.dart';

class Role extends BaseObject with ObjectWithColor, ObjectWithName, ProfileLinkedObject, ChannelLinkedObject {


  Role (Map<String, dynamic> dictionary) : super(dictionary);


  Role.create({ String name }) : super({
    Keys().name: name
  });

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    parseColorInfo(dictionary);
    parseNameInfo(dictionary);
    parseChannelLink(dictionary);
    parseProfileLink(dictionary);
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
    dictionary.addAll(colorInfoDictionary());
    dictionary.addAll(nameDictionary());
    dictionary.addAll(profileLinkDictionary());
    dictionary.addAll(channelLinkDictionary());
    return dictionary;
  }

}
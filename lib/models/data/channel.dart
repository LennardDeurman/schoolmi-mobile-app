import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/models/data/extensions/object_with_colorindex.dart';
import 'package:schoolmi/models/data/extensions/object_with_avatar.dart';
import 'package:schoolmi/models/parsable_object.dart';
import 'package:schoolmi/network/auth/login_result.dart';

class Channel extends BaseObject with ObjectWithColorIndex, ObjectWithAvatar {

  String name;
  String description;
  String imageUrl;
  int membersCount;
  bool isUserAdmin;
  bool canAddTags;
  bool canPublicJoin;
  bool isActiveChannel;

  Channel (Map<String, dynamic> dictionary) : super(dictionary);

  @override
  String get avatarImageUrl {
    return imageUrl;
  }

  @override
  int get avatarColorIndex {
    return colorIndex;
  }

  @override
  String get firstLetter {
    return firstLetterOrEmpty(name);
  }


  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    parseColorIndex(dictionary);
    id = dictionary[Keys.channelId];
    name = dictionary[Keys.name];
    description = dictionary[Keys.description];
    imageUrl = dictionary[Keys.imageUrl];
    membersCount = dictionary[Keys.membersCount] ?? 0;
    isUserAdmin = ParsableObject.parseBool(dictionary[Keys.isAdmin]);
    isActiveChannel = ParsableObject.parseBool(dictionary[Keys.isActive]);
    canAddTags = ParsableObject.parseBool(dictionary[Keys.canAddTags]);
    canPublicJoin = ParsableObject.parseBool(dictionary[Keys.canPublicJoin]);
  }

  @override
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> superDict = super.toDictionary();
    superDict.addAll(colorDictionary());
    superDict[Keys.name] = name;
    superDict[Keys.description] = description;
    superDict[Keys.imageUrl] = imageUrl;
    superDict[Keys.membersCount] = membersCount;
    superDict[Keys.isAdmin] = isUserAdmin;
    superDict[Keys.isActive] = isActiveChannel;
    superDict[Keys.canAddTags] = canAddTags;
    superDict[Keys.canPublicJoin] = canPublicJoin;
    superDict[Keys.channelId] = id;
    return superDict;
  }

}
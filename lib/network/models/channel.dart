import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/models/extensions/object_with_avatar.dart';
import 'package:schoolmi/network/models/extensions/object_with_color.dart';
import 'package:schoolmi/network/models/extensions/object_with_name.dart';
import 'package:schoolmi/network/models/linkages/profile_linked_object.dart';

class Channel extends BaseObject with ObjectWithColor, ObjectWithName, ObjectWithAvatar, ProfileLinkedObject {

  String description;
  String imageUrl;
  int membersCount;
  int updatesCount;
  bool isCurrentUserAdmin;
  bool canAddTags;
  bool canPublicJoin;
  bool isActiveChannel;

  Channel (Map<String, dynamic> dictionary) : super(dictionary);


  @override
  String get firstLetter {
    return firstLetterOrEmpty(name);
  }


  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    parseColorInfo(dictionary);
    parseAvatarInfo(dictionary);
    parseNameInfo(dictionary);
    parseProfileLink(dictionary);

    description = dictionary[Keys().description];
    imageUrl = dictionary[Keys().imageUrl];
    membersCount = ParsableObject.parseIntOrZero(dictionary[Keys().membersCount]);
    updatesCount = ParsableObject.parseIntOrZero(dictionary[Keys().updatesCount]);
    isCurrentUserAdmin = ParsableObject.parseBool(dictionary[Keys().isCurrentUserAdmin]);
    isActiveChannel = ParsableObject.parseBool(dictionary[Keys().isActiveChannel]);
    canAddTags = ParsableObject.parseBool(dictionary[Keys().canAddTags]);
    canPublicJoin = ParsableObject.parseBool(dictionary[Keys().canPublicJoin]);

  }

  @override
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> superDict = super.toDictionary();
    superDict.addAll(colorInfoDictionary());
    superDict.addAll(avatarDictionary());
    superDict.addAll(nameDictionary());
    superDict.addAll(profileLinkDictionary());
    superDict[Keys().description] = description;
    superDict[Keys().imageUrl] = imageUrl;
    superDict[Keys().membersCount] = membersCount;
    superDict[Keys().isCurrentUserAdmin] = isCurrentUserAdmin;
    superDict[Keys().isActiveChannel] = isActiveChannel;
    superDict[Keys().canAddTags] = canAddTags;
    superDict[Keys().canPublicJoin] = canPublicJoin;
    superDict[Keys().channelId] = id;
    return superDict;
  }

}
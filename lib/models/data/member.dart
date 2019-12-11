
import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/models/data/profile.dart';
import 'package:schoolmi/models/data/extensions/object_with_avatar.dart';


class Member extends BaseObject with ObjectWithAvatar  {
  String email;
  int channelId;
  bool isAdmin;

  Member (Map<String, dynamic> dictionary) : super(dictionary);

  @override
  String get firstLetter {
    return firstLetterOrEmpty(email);
  }

  @override
  String get avatarImageUrl {
    return null;
  }

  @override
  int get avatarColorIndex {
    return null;
  }

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    email = dictionary[Keys.email];
    channelId = dictionary[Keys.channelId];
    isAdmin = dictionary[Keys.isAdmin];
    profile = Profile(dictionary);
  }

  @override
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> superDict = super.toDictionary();
    superDict[Keys.email] = email;
    superDict[Keys.channelId] = channelId;
    superDict[Keys.isAdmin] = isAdmin;
    return superDict;
  }
}

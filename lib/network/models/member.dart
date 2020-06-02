
import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/models/data/linkages/channel_linked_object.dart';
import 'package:schoolmi/models/data/linkages/profile_linked_object.dart';
import 'package:schoolmi/models/data/extensions/object_with_avatar.dart';
import 'package:schoolmi/models/data/role.dart';
import 'package:schoolmi/network/models/parsable_object.dart';
import 'package:schoolmi/network/auth/user_service.dart';


class Member extends BaseObject with ObjectWithAvatar, ChannelLinkedObject, ProfileLinkedObject  {

  String email;
  bool isAdmin;
  bool blocked;

  int roleId;
  Role role;

  Member (Map<String, dynamic> dictionary) : super(dictionary);

  Member.create({ email, channelId, isAdmin = false }) : super({
    Keys().email: email,
    Keys().channelId: channelId,
    Keys().isAdmin: isAdmin
  });

  bool get isCurrentUser {
    var result = UserService().loginResult;
    if (result.firebaseUser != null) {
      if (result.firebaseUser.email == email) {
        return true;
      }
    }
    return false;
  }

  bool get hasRole {
    bool hasRole = role != null;
    if (hasRole) {
      return role.name != null;
    }
    return false;
  }

  @override
  String get firstLetter {
    return firstLetterOrEmpty(email);
  }



  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);

    email = dictionary[Keys().email];
    channelId = dictionary[Keys().channelId];
    blocked = ParsableObject.parseBool(dictionary[Keys().blocked]);
    isAdmin = ParsableObject.parseBool(dictionary[Keys().isAdmin]);


    roleId = dictionary[Keys().roleId];
    Map<String, dynamic> roleDictionary = dictionary[Keys().role];
    if (roleDictionary != null) {
      role = Role(roleDictionary);
    }

    parseProfileLink(dictionary);

    if (profile != null) {
      imageUrl = profile.imageUrl;
    }

  }

  @override
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> superDict = super.toDictionary();
    superDict[Keys().email] = email;
    superDict[Keys().channelId] = channelId;
    superDict[Keys().isAdmin] = isAdmin;
    superDict[Keys().blocked] = blocked;
    superDict[Keys().roleId] = roleId;
    superDict[Keys().role] = ParsableObject.tryGetDict(role);
    superDict.addAll(channelLinkDictionary());
    superDict.addAll(profileLinkDictionary());
    superDict.addAll(avatarDictionary());
    return superDict;
  }
}

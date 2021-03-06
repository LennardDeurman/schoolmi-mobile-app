
import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/models/extensions/object_with_color.dart';
import 'package:schoolmi/network/models/linkages/channel_linked_object.dart';
import 'package:schoolmi/network/models/linkages/profile_linked_object.dart';
import 'package:schoolmi/network/models/extensions/object_with_avatar.dart';
import 'package:schoolmi/network/models/role.dart';
import 'package:schoolmi/network/auth/user_service.dart';


class Member extends BaseObject with ObjectWithAvatar, ObjectWithColor, ChannelLinkedObject, ProfileLinkedObject  {

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
    var result = UserService().userResult;
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
    return firstLetterOrEmpty(profile != null ? profile.firstLetter : (email ?? "?"));
  }



  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);

    email = dictionary[Keys().email];
    channelId = dictionary[Keys().channelId];
    blocked = ParsableObject.parseBool(dictionary[Keys().blocked]);
    isAdmin = ParsableObject.parseBool(dictionary[Keys().isAdmin]);
    colorIndex = 0;

    roleId = dictionary[Keys().roleId];
    Map<String, dynamic> roleDictionary = dictionary[Keys().role];
    if (roleDictionary != null) {
      role = Role(roleDictionary);
    }

    parseProfileLink(dictionary);

    if (profile != null) {
      imageUrl = profile.imageUrl;
      colorIndex = profile.colorIndex;
    }

  }

  @override
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> superDict = super.toDictionary();
    superDict[Keys().email] = email;
    superDict[Keys().channelId] = channelId;
    superDict[Keys().isAdmin] = isAdmin;
    superDict[Keys().blocked] = blocked;
    superDict[Keys().roleId] = role != null ? role.id : roleId;
    superDict[Keys().role] = ParsableObject.tryGetDict(role);
    superDict.addAll(channelLinkDictionary());
    superDict.addAll(profileLinkDictionary());
    superDict.addAll(avatarDictionary());
    return superDict;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(other) {
    if (other is Member) {
      Member member = other;
      return member.email == this.email;
    }
    return super == other;
  }
}

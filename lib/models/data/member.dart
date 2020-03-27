
import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/models/data/profile.dart';
import 'package:schoolmi/models/data/extensions/object_with_avatar.dart';
import 'package:schoolmi/models/data/role.dart';
import 'package:schoolmi/models/parsable_object.dart';
import 'package:schoolmi/network/auth/user_service.dart';


class Member extends BaseObject with ObjectWithAvatar  {
  String email;
  int channelId;
  bool isAdmin;
  bool blocked;
  Role role;

  Member (Map<String, dynamic> dictionary) : super(dictionary);

  Member.create({ email, channelId, isAdmin = false }) : super({
    Keys.email: email,
    Keys.channelId: channelId,
    Keys.isAdmin: isAdmin
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
  String get avatarImageUrl {
    return profile != null ? profile.avatarImageUrl : null;
  }

  @override
  int get avatarColorIndex {
    return profile != null ? profile.colorIndex : 0;
  }


  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    email = dictionary[Keys.email];
    channelId = dictionary[Keys.channelId];
    blocked = ParsableObject.parseBool(dictionary[Keys.blocked]);
    isAdmin = ParsableObject.parseBool(dictionary[Keys.isAdmin]);
    profile = Profile(dictionary);
    profile.colorIndex = dictionary[Keys.colorIndex];
    int roleId = dictionary[Keys.roleId];
    if (roleId != null) {
      role = Role(dictionary);
    }
    if (profile.firebaseUid == null) {
      profile = null;
    }
  }

  @override
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> superDict = super.toDictionary();
    superDict[Keys.email] = email;
    superDict[Keys.channelId] = channelId;
    superDict[Keys.isAdmin] = isAdmin;
    superDict[Keys.blocked] = blocked;
    if (role != null) {
      superDict[Keys.roleId] = role.id;
    }
    return superDict;
  }
}

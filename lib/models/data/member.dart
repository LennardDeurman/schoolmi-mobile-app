
import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/models/data/profile.dart';
import 'package:schoolmi/models/data/extensions/object_with_avatar.dart';
import 'package:schoolmi/network/auth/user_service.dart';


class Member extends BaseObject with ObjectWithAvatar  {
  String email;
  int channelId;
  bool isAdmin;

  Member (Map<String, dynamic> dictionary) : super(dictionary);

  bool get isCurrentUser {
    var result = UserService().loginResult;
    if (result.firebaseUser != null) {
      if (result.firebaseUser.email == email) {
        return true;
      }
    }
    return false;
  }

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

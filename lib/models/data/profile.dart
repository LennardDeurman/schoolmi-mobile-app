import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/models/data/extensions/object_with_colorindex.dart';
import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/data/extensions/object_with_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class Profile extends BaseObject with ObjectWithColorIndex, ObjectWithAvatar {

  String username;
  String firstName;
  String lastName;
  String profileImageUrl;
  String about;
  String email;
  String firebaseUid;
  int score;
  int profileId;
  int activeChannelId;

  static const String storageKey = "storageKey";

  @override
  String get avatarImageUrl {
    return profileImageUrl;
  }

  @override
  int get avatarColorIndex {
    return colorIndex;
  }

  @override
  String get firstLetter {
    return firstLetterOrEmpty(username);
  }

  String get fullName {
    if (firstName != null && lastName != null) {
      return firstName + " " + lastName;
    } else if (firstName != null) {
      return firstName;
    } else if (lastName != null) {
      return lastName;
    }
    return "";
  }

  bool get hasActiveChannel {
    return activeChannelId > 0;
  }

  Profile (Map<String, dynamic> dictionary) : super(dictionary);

  @override
  void parse(Map<String, dynamic> dictionary) {
    username = dictionary[Keys.username];
    firstName = dictionary[Keys.firstName];
    lastName = dictionary[Keys.lastName];
    profileImageUrl = dictionary[Keys.profileImageUrl];
    about = dictionary[Keys.about];
    email = dictionary[Keys.email];
    score = (dictionary[Keys.score] ?? dictionary[Keys.profileScore]) ?? 0;
    profileId = dictionary[Keys.profileId];
    activeChannelId = dictionary[Keys.activeChannelId];
    firebaseUid = dictionary[Keys.firebaseUid];
    super.parse(dictionary);
  }

  @override
  Map<String, dynamic> toDictionary() {
    return {
      Keys.username: username,
      Keys.firstName: firstName,
      Keys.lastName: lastName,
      Keys.profileImageUrl: profileImageUrl,
      Keys.about: about,
      Keys.email: email,
      Keys.score: score,
      Keys.profileId: profileId,
      Keys.activeChannelId: activeChannelId,
      Keys.firebaseUid: firebaseUid
    };
  }


  static Future<void> setCachedInfo({ String email, String firstName, String lastName, String username}) async {
    Profile profile = Profile({
      Keys.username: username,
      Keys.firstName: firstName,
      Keys.lastName: lastName,
      Keys.email: email
    });
    String jsonStr = json.encode(profile.toDictionary());
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(storageKey, jsonStr);

  }

  static Future<Profile> cachedProfile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jsonStr = sharedPreferences.get(Profile.storageKey);
    if (jsonStr != null) {
      Map<String, dynamic> jsonMap = json.decode(jsonStr) as Map;
      return Profile(jsonMap);
    }
    return Profile({});
  }



}
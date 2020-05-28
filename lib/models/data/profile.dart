import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/models/parsable_object.dart';
import 'package:schoolmi/models/data/extensions/object_with_color.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/data/extensions/object_with_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class Profile extends BaseObject with ObjectWithColor, ObjectWithAvatar {

  String username;
  String firstName;
  String lastName;
  String email;
  String firebaseUid;
  int score;

  int activeChannelId;
  Channel activeChannel;

  static const String storageKey = "storageKey";


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
    username = dictionary[Keys().username];
    firstName = dictionary[Keys().firstName];
    lastName = dictionary[Keys().lastName];
    email = dictionary[Keys().email];
    score = ParsableObject.parseIntOrZero(dictionary[Keys().score]);
    firebaseUid = dictionary[Keys().firebaseUid];
    parseMyChannelInfo(dictionary);
    parseAvatarInfo(dictionary);
    parseColorInfo(dictionary);
    super.parse(dictionary);
  }

  void parseMyChannelInfo(Map<String, dynamic> dictionary) {
    activeChannelId = dictionary[Keys().activeChannelId];
    Map channelDictionary = dictionary[Keys().activeChannel];
    if (channelDictionary != null) {
      activeChannel = Channel(channelDictionary);
    }
  }

  @override
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> superdict = super.toDictionary();

    superdict = {
      Keys().username: username,
      Keys().firstName: firstName,
      Keys().lastName: lastName,
      Keys().email: email,
      Keys().score: score,
      Keys().activeChannelId: activeChannelId,
      Keys().activeChannel: ParsableObject.tryGetDict(activeChannel),
      Keys().firebaseUid: firebaseUid
    };


    superdict.addAll(avatarDictionary());
    superdict.addAll(colorInfoDictionary());

    return superdict;

  }


  static Future<void> setCachedInfo({ String email, String firstName, String lastName, String username}) async {
    Profile profile = Profile({
      Keys().username: username,
      Keys().firstName: firstName,
      Keys().lastName: lastName,
      Keys().email: email
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
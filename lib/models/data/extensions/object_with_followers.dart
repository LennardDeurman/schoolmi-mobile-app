import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/parsable_object.dart';

class ObjectWithFollowers {

  int followersCount;
  bool followedByMe;

  void parseFollowersInfo(Map<String, dynamic> dictionary) {
    followersCount = ParsableObject.parseIntOrZero(dictionary[Keys().followersCount]);
    followedByMe = ParsableObject.parseBool(dictionary[Keys().followedByMe]);
  }

  Map<String, dynamic> followersDictionary() {
    return {
      Keys().followersCount: followersCount,
      Keys().followedByMe: followedByMe
    };
  }

}
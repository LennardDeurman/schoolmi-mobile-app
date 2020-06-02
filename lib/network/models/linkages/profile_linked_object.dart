import 'package:schoolmi/models/data/profile.dart';
import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/network/models/parsable_object.dart';

class ProfileLinkedObject {

    String firebaseUid;
    Profile profile;

    void parseProfileLink(Map<String, dynamic> dictionary) {
      firebaseUid = dictionary[Keys().firebaseUid];
      Map profileDictionary = dictionary[Keys().profile];
      if (profileDictionary != null) {
          profile = Profile(profileDictionary);
      }
    }

    Map<String, dynamic> profileLinkDictionary() {
      return {
        Keys().firebaseUid: firebaseUid,
        Keys().profile: ParsableObject.tryGetDict(profile)
      };
    }

}
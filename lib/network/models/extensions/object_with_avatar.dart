import 'package:schoolmi/network/models/extensions/object_with_color.dart';
import 'package:schoolmi/network/keys.dart';

abstract class ObjectWithAvatar {

  String get firstLetter;

  String imageUrl;

  void parseAvatarInfo(Map<String, dynamic> dictionary) {
      imageUrl = dictionary[Keys().imageUrl];
  }


  bool get hasImage {
    String firstLetter = this.firstLetter;
    bool hasFirstLetter = false;
    if (firstLetter != null) {
      hasFirstLetter = firstLetter.length > 0;
    }
    return hasCustomImage || hasFirstLetter;
  }

  bool get hasCustomImage {
    return imageUrl != null;
  }

  String firstLetterOrNull (String value) {
    if (value != null) {
      if (value.length > 0) {
        return value.substring(0, 1).toUpperCase();
      }
    }
    return null;
  }


  String firstLetterOrEmpty (String value) {
    if (value != null) {
      if (value.length > 0) {
        return value.substring(0, 1).toUpperCase();
      }
    }
    return "";
  }

  Map<String, dynamic> avatarDictionary() {
    return {
      Keys().imageUrl: imageUrl
    };
  }



}
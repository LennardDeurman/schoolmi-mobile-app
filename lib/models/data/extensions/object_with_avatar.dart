abstract class ObjectWithAvatar {

  String get firstLetter;

  String get avatarImageUrl;

  int get avatarColorIndex;


  bool get hasImage {
    String firstLetter = this.firstLetter;
    bool hasFirstLetter = false;
    if (firstLetter != null) {
      hasFirstLetter = firstLetter.length > 0;
    }
    return hasCustomImage || hasFirstLetter;
  }

  bool get hasCustomImage {
    return avatarImageUrl != null;
  }

  String firstLetterOrNull (String value) {
    if (value != null) {
      if (value.length > 0) {
        return value.substring(0, 1);
      }
    }
    return null;
  }


  String firstLetterOrEmpty (String value) {
    if (value != null) {
      if (value.length > 0) {
        return value.substring(0, 1);
      }
    }
    return "";
  }



}
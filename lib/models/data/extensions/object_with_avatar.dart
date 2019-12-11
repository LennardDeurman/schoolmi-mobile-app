abstract class ObjectWithAvatar {

  String get firstLetter;

  String get avatarImageUrl;

  int get avatarColorIndex;


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
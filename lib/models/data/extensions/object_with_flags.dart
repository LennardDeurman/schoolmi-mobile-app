import 'package:schoolmi/constants/keys.dart';
class ObjectWithFlags {


  bool flagged;
  bool parentFlagged;
  bool duplicated;
  bool flaggedByMe;
  bool flaggedDuplicateByMe;
  bool commentsFlagged;

  void parseFlagInfo(Map<String, dynamic> dictionary) {
    flagged = dictionary[Keys.flagged];
    flaggedByMe = dictionary[Keys.flaggedByMe];
    parentFlagged = dictionary[Keys.parentFlagged];
    duplicated = dictionary[Keys.duplicated];
    flaggedDuplicateByMe = dictionary[Keys.flaggedDuplicateByMe];
    commentsFlagged = dictionary[Keys.commentsFlagged];
  }

  Map<String, dynamic> flagInfoDictionary() {
    return {
      Keys.flagged: flagged,
      Keys.flaggedByMe: flaggedByMe,
      Keys.parentFlagged: parentFlagged,
      Keys.duplicated: duplicated,
      Keys.flaggedDuplicateByMe: flaggedDuplicateByMe,
      Keys.commentsFlagged: commentsFlagged
    };
  }

}
import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/parsable_object.dart';
class ObjectWithFlags {


  bool flagged;
  bool parentFlagged;
  bool duplicated;
  bool flaggedByMe;
  bool flaggedDuplicateByMe;
  bool commentsFlagged;

  void parseFlagInfo(Map<String, dynamic> dictionary) {
    flagged = ParsableObject.parseBool(dictionary[Keys.flagged]);
    flaggedByMe = ParsableObject.parseBool(dictionary[Keys.flaggedByMe]);
    parentFlagged = ParsableObject.parseBool(dictionary[Keys.parentFlagged]);
    duplicated = ParsableObject.parseBool(dictionary[Keys.duplicated]);
    flaggedDuplicateByMe = ParsableObject.parseBool(dictionary[Keys.flaggedDuplicateByMe]);
    commentsFlagged = ParsableObject.parseBool(dictionary[Keys.commentsFlagged]);
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
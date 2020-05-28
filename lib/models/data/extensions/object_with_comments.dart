import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/parsable_object.dart';

class ObjectWithComments  {

  int commentsCount;
  int commentsUpdates;

  void parseCommentsInfo(Map<String, dynamic> dictionary) {
    commentsCount = ParsableObject.parseIntOrZero(dictionary[Keys().commentsCount]);
    commentsUpdates = ParsableObject.parseIntOrZero(dictionary[Keys().commentsUpdates]);
  }

  Map<String, dynamic> commentsInfoDictionary() {
    return {
      Keys().commentsCount: commentsCount,
      Keys().commentsUpdates: commentsUpdates
    };
  }
}
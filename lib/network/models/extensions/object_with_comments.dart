import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/network/models/abstract/base.dart';

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
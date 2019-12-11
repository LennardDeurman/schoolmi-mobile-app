import 'package:schoolmi/models/parsable_object.dart';
import 'package:schoolmi/constants/keys.dart';

class ObjectWithComments  {

  int commentsCount;

  void parseCommentInfo(Map<String, dynamic> dictionary) {
    commentsCount = dictionary[Keys.commentsCount] ?? 0;
  }

  Map<String, dynamic> commentsDictionary() {
    return {
      Keys.commentsCount: commentsCount
    };
  }
}
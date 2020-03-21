import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/extensions/dates.dart';
import 'package:schoolmi/models/parsable_object.dart';

class ObjectWithViewCount {

  int viewCount;
  DateTime viewTime;
  bool isSeen;

  void parseViewCount (Map<String, dynamic> dictionary) {
    viewCount = dictionary[Keys.viewCount];
    viewTime = Dates.parse(dictionary[Keys.viewTime]);
    isSeen = ParsableObject.parseBool(dictionary[Keys.isSeen]);
  }

  Map<String, dynamic> viewsDictionary() {
    return {
      Keys.viewCount: viewCount,
      Keys.viewTime: viewTime,
      Keys.isSeen: isSeen
    };
  }


}
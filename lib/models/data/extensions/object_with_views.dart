import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/parsable_object.dart';

class ObjectWithViews {

  int viewCount;
  DateTime questionViewTime;

  bool isNew;
  bool isUpdated;


  void parseViewsInfo (Map<String, dynamic> dictionary) {
    viewCount = ParsableObject.parseIntOrZero(dictionary[Keys().viewCount]);
    questionViewTime = ParsableObject.parseDate(dictionary[Keys().questionViewTime]);
    isUpdated = ParsableObject.parseBool(dictionary[Keys().isUpdated]);
    isNew = ParsableObject.parseBool(dictionary[Keys().isNew]);
  }

  Map<String, dynamic> viewsDictionary() {
    return {
      Keys().viewCount: viewCount,
      Keys().questionViewTime: questionViewTime,
      Keys().isUpdated: isUpdated,
      Keys().isNew: isNew
    };
  }


}
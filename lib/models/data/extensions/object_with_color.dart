import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/parsable_object.dart';

class ObjectWithColor  {

  int colorIndex;

  void parseColorInfo(Map<String, dynamic> dictionary) {
    colorIndex = ParsableObject.parseIntOrZero(dictionary[Keys().colorIndex]);
  }

  Map<String, dynamic> colorInfoDictionary() {
    return {
      Keys().colorIndex: colorIndex
    };
  }
}

import 'package:schoolmi/constants/keys.dart';

class ObjectWithColorIndex  {

  int colorIndex;

  void parseColorIndex(Map<String, dynamic> dictionary) {
    colorIndex = dictionary[Keys.colorIndex] ?? 0;
  }

  Map<String, dynamic> colorDictionary() {
    return {
      Keys.colorIndex: colorIndex
    };
  }
}

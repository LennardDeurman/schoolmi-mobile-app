import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/network/models/abstract/base.dart';

class ObjectWithFlags {


  int flagsCount;
  bool flaggedByMe;

  void parseFlagsInfo(Map<String, dynamic> dictionary) {
    flagsCount = ParsableObject.parseIntOrZero(dictionary[Keys().flagsCount]);
    flaggedByMe = ParsableObject.parseBool(dictionary[Keys().flaggedByMe]);
  }

  bool get flagged {
    return flagsCount > 0;
  }

  Map<String, dynamic> flagsInfoDictionary() {
    return {
      Keys().flagged: flagged,
      Keys().flagsCount: flagsCount,
      Keys().flaggedByMe: flaggedByMe
    };
  }

}
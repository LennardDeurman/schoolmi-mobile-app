import 'package:schoolmi/constants/keys.dart';

class ContentLinkedObject {

  String parentContentUuid;

  void parseContentLink(Map<String, dynamic> dictionary) {
    parentContentUuid = dictionary[Keys().parentContentUuid];
  }

  Map<String, dynamic> contentLinkDictionary() {
    return {
      Keys().parentContentUuid: parentContentUuid
    };
  }


}
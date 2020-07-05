

import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/models/abstract/content_child_object.dart';
import 'package:schoolmi/network/models/settings/event_preferences.dart';
import 'package:schoolmi/network/keys.dart';


class ContentVersion extends ContentChildObject {

  String body;
  int copyOfVersionId;
  int id;
  ContentVersion copyOfVersion;

  ContentVersion (Map<String, dynamic> dictionary) : super(dictionary);

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);

    body = dictionary[Keys().body];
    id = dictionary[Keys().id];
    copyOfVersionId = dictionary[Keys().copyOfVersionId];

    copyOfVersion = ParsableObject.parseObject(dictionary[Keys().copyOfVersion], objectCreator: (Map<String, dynamic> dict) {
      return ContentVersion(dict);
    });
  }

  @override
  Map<String, dynamic> toDictionary() {
    var dict = super.toDictionary();
    dict.addAll({
      Keys().body: body,
      Keys().id: id,
      Keys().copyOfVersionId: copyOfVersionId,
      Keys().copyOfVersion: copyOfVersion.toDictionary()
    });
    return dict;
  }

}




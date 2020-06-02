import 'package:schoolmi/network/models/abstract/content_object.dart';
import 'package:schoolmi/models/data/linkages/content_linked_object.dart';

class Comment extends ContentObject with ContentLinkedObject {

  Comment (Map<String, dynamic> dictionary) : super(dictionary);

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    parseContentLink(dictionary);
  }

  @override
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> superDict = super.toDictionary();
    superDict.addAll(contentLinkDictionary());
    return superDict;
  }

}


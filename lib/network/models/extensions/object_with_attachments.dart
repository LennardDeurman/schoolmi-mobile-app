import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/models/attachment.dart';
import 'package:schoolmi/network/keys.dart';

class ObjectWithAttachments {

  List<Attachment> attachments;

  void parseAttachments(Map<String, dynamic> dictionary) {
      attachments = ParsableObject.parseObjectsList(dictionary, Keys().attachments, objectCreator: (Map dict) {
        return Attachment(dict);
      });
  }

  Map<String, dynamic> attachmentsDictionary() {
    return {
      Keys().attachments: attachments.map((e) => e.toDictionary()).toList()
    };
  }

}
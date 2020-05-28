import 'package:schoolmi/models/parsable_object.dart';
import 'package:schoolmi/models/data/attachment.dart';
import 'package:schoolmi/constants/keys.dart';

class ObjectWithAttachments {

  List<Attachment> attachments;

  void parseAttachments(Map<String, dynamic> dictionary) {
      attachments = ParsableObject.parseObjectsList(dictionary, Keys().attachments, toObject: (Map dict) {
        return Attachment(dict);
      });
  }

  Map<String, dynamic> attachmentsDictionary() {
    return {
      Keys().attachments: attachments.map((e) => e.toDictionary()).toList()
    };
  }

}
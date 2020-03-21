import 'package:schoolmi/models/parsable_object.dart';
import 'package:schoolmi/models/data/attachment.dart';
import 'package:schoolmi/constants/keys.dart';

class ObjectWithAttachments {

  List<Attachment> attachments;

  void parseAttachments(Map<String, dynamic> dictionary) {
    attachments = ParsableObject.parseObjectsList<Attachment>(dictionary, Keys.attachments, toObject: (Map dictionary) {
      return Attachment(dictionary);
    });
  }

  Map<String, dynamic> attachmentsDictionary() {
    return {
      Keys.attachments: attachments.map((Attachment attachment) {
        return attachment.toDictionary();
      }).toList()
    };
  }

}
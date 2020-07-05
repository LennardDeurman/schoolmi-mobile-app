import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/models/extensions/object_with_default_props.dart';
import 'package:schoolmi/network/models/linkages/channel_linked_object.dart';
import 'package:schoolmi/network/models/linkages/profile_linked_object.dart';
import 'package:schoolmi/network/keys.dart';

class Upload extends BaseObject with ChannelLinkedObject, ProfileLinkedObject {

  String uploadUrl;
  String localFileName;
  bool isImage;
  int width;
  int height;
  String mode;
  String miniUrl;

  Upload (Map<String, dynamic> dictionary) : super(dictionary);

  @override
  void parse(Map<String, dynamic> dictionary) {
    uploadUrl = dictionary[Keys().uploadUrl];
    localFileName = dictionary[Keys().localFileName];
    isImage = ParsableObject.parseBool(dictionary[Keys().isImage]);
    width = dictionary[Keys().width];
    height = dictionary[Keys().height];
    mode = dictionary[Keys().mode];
    miniUrl = dictionary[Keys().miniUrl];
    parseProfileLink(dictionary);
    parseChannelLink(dictionary);
  }

  @override
  Map<String, dynamic> toDictionary() {
    Map superDict = super.toDictionary();
    Map thisDict = {
      Keys().uploadUrl: uploadUrl,
      Keys().localFileName: localFileName,
      Keys().isImage: isImage,
      Keys().width: width,
      Keys().height: height,
      Keys().mode: mode,
      Keys().miniUrl: miniUrl
    };
    superDict.addAll(thisDict);
    superDict.addAll(profileLinkDictionary());
    superDict.addAll(channelLinkDictionary());
    return superDict;
  }

}

class Attachment extends ParsableObject with ObjectWithDefaultProps {

  int uploadId;
  Upload upload;


  Attachment (Map<String, dynamic> dictionary){
    parse(dictionary);
  }

  @override
  void parse(Map<String, dynamic> dictionary) {
    uploadId = dictionary[Keys().uploadId];
    Map uploadDictionary = dictionary[Keys().upload];
    if (uploadDictionary != null) {
      this.upload = Upload(uploadDictionary);
    }
    parseDefaultProps(dictionary);
  }


  @override
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> dict = {};
    dict.addAll(defaultPropsDictionary());

    dict.addAll({
      Keys().uploadId: uploadId,
      Keys().upload: ParsableObject.tryGetDict(upload)
    });

    return dict;
  }

}
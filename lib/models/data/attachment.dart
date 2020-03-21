import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/constants/keys.dart';


class Attachment extends BaseObject {

  String url;
  String mini;

  Attachment (Map<String, dynamic> dictionary) : super(dictionary);

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);

    url = dictionary[Keys.url];
    mini = dictionary[Keys.mini];
  }

  String get name {
    if (url != null) {
      if (url.length > 20) {
        return url.substring(url.length - 20, url.length);
      } else {
        return url;
      }
    }
    return "";
  }

  bool get isImage {
    return mini != null;
  }

  @override
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> superDict = super.toDictionary();
    superDict[Keys.url] = url;
    superDict[Keys.mini] = mini;
    return superDict;
  }

}
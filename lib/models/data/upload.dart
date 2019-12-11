import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/constants/keys.dart';
class Upload extends BaseObject {

  String url;
  String mini;

  Upload (Map<String, dynamic> dictionary) : super(dictionary);

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    url = dictionary[Keys.url];
    mini = dictionary[Keys.mini];
  }
}
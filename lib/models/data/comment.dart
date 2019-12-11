import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/data/extensions/object_with_flags.dart';
import 'package:schoolmi/models/base_object.dart';

class Comment extends BaseObject with ObjectWithFlags {

  String body;

  Comment (Map<String, dynamic> dictionary) : super(dictionary);

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    parseFlagInfo(dictionary);
    body = dictionary[Keys.body];
  }

  @override
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> superDict = super.toDictionary();
    superDict.addAll(flagInfoDictionary());
    superDict[Keys.body] = body;
    return superDict;
  }
}
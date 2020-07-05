import 'package:schoolmi/network/models/abstract/content_child_object.dart';
import 'package:schoolmi/network/keys.dart';

class ContentFlag extends ContentChildObject {

  String reason;

  ContentFlag (Map<String, dynamic> dictionary) : super(dictionary);

  @override
  Map<String, dynamic> toDictionary() {
    var superDict = super.toDictionary();
    superDict[Keys().reason] = reason;
    return superDict;
  }

}
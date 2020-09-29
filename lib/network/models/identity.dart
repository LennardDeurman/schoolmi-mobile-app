import 'package:schoolmi/network/models/member.dart';
import 'package:schoolmi/network/models/profile.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/keys.dart';

class Identity extends ParsableObject {

  Member member;
  Profile profile;

  Identity ({ this.member, this.profile });

  Identity.fromDictionary(Map<String, dynamic> dictionary) {
    parse(dictionary);
  }

  @override
  void parse(Map<String, dynamic> dictionary) {
    member = ParsableObject.parseObject(ParsableObject.dictOrFirst(dictionary[Keys().member]), objectCreator: (Map<String, dynamic> dict) {
      return Member(dict);
    });

    profile = ParsableObject.parseObject(ParsableObject.dictOrFirst(dictionary[Keys().profile]), objectCreator: (Map<String, dynamic> dict) {
      return Profile(dict);
    });
  }

  @override
  Map<String, dynamic> toDictionary() {
    throw UnimplementedError();
  }

}
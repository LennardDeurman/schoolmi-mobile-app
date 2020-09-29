import 'package:schoolmi/network/models/linkages/content_linked_object.dart';
import 'package:schoolmi/network/models/linkages/profile_linked_object.dart';
import 'package:schoolmi/network/models/extensions/object_with_default_props.dart';
import 'package:schoolmi/network/models/member.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/network/models/linkages/identity_linked_object.dart';
import 'package:schoolmi/network/models/identity.dart';

class ContentChildObject extends ParsableObject with ContentLinkedObject, ObjectWithDefaultProps, ProfileLinkedObject, IdentityLinkedObject {

  Member member;

  ContentChildObject (Map<String, dynamic> dictionary) {
    parse(dictionary);
  }

  @override
  void parse(Map<String, dynamic> dictionary) {
    parseDefaultProps(dictionary);
    parseProfileLink(dictionary);
    parseContentLink(dictionary);


    member = ParsableObject.parseObject(ParsableObject.dictOrFirst(dictionary[Keys().member]), objectCreator: (Map<String, dynamic> dict) {
      return Member(dict);
    });
  }

  @override
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> dict = {
      Keys().member: ParsableObject.tryGetDict(member)
    };
    dict.addAll(defaultPropsDictionary());
    dict.addAll(profileLinkDictionary());
    dict.addAll(contentLinkDictionary());
    return dict;
  }

  Identity get identity {
    return Identity(member: member, profile: profile);
  }
}
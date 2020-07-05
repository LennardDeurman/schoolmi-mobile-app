import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/models/answer.dart';
import 'package:schoolmi/network/models/abstract/content_object.dart';
import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/network/models/extensions/object_with_tags.dart';
import 'package:schoolmi/network/models/identity.dart';

class DuplicateQuestion extends Question {

  List<Identity> reporters;

  DuplicateQuestion (Map<String, dynamic> dictionary) : super(dictionary);

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);

    reporters = ParsableObject.parseObjectsList(dictionary, Keys().reporters, objectCreator: (Map<String, dynamic> map) {
      return Identity.fromDictionary(map);
    });

  }


}

class Question extends ContentObject with ObjectWithTags {

  int answerCount;
  int correctAnswerId;
  bool flaggedDuplicateByMe;
  int duplicateFlagsCount;
  Answer correctAnswer;

  Question (Map<String, dynamic> dictionary) : super(dictionary);

  bool get hasCheckedAnswer {
    return correctAnswerId != null;
  }

  bool isSelectedAnswer (Answer answer) {
    return correctAnswerId == answer.id;
  }

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    parseTags(dictionary);

    correctAnswerId = dictionary[Keys().correctAnswerId];
    answerCount = ParsableObject.parseIntOrZero(dictionary[Keys().answerCount]);
    flaggedDuplicateByMe = ParsableObject.parseBool(dictionary[Keys().flaggedDuplicateByMe]);
    duplicateFlagsCount = ParsableObject.parseIntOrZero(dictionary[Keys().duplicateFlagsCount]);

    correctAnswer = ParsableObject.parseObject(dictionary[Keys().correctAnswer], objectCreator: (map) {
      return Answer(map);
    });

  }

  @override
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> superDict = super.toDictionary();
    superDict.addAll(tagsDictionary());
    return superDict;
  }
}

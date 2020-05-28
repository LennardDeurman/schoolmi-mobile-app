import 'package:schoolmi/models/data/answer.dart';
import 'package:schoolmi/models/content_object.dart';
import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/data/extensions/object_with_tags.dart';

class Question extends ContentObject with ObjectWithTags {

  int correctAnswerId;
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
    Map<String, dynamic> correctAnswerDict = dictionary[Keys().correctAnswer];
    if (correctAnswerDict != null) {
      correctAnswer = Answer(correctAnswerDict);
    }
  }

  @override
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> superDict = super.toDictionary();
    superDict.addAll(tagsDictionary());
    return superDict;
  }
}

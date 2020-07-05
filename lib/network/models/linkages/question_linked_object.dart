import 'package:schoolmi/network/models/question.dart';
import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/network/models/abstract/base.dart';

class QuestionLinkedObject {

  int questionId;
  Question question;

  void parseQuestionLink(Map<String, dynamic> dictionary) {
    questionId = dictionary[Keys().questionId];
    Map questionDictionary = dictionary[Keys().question];
    if (questionDictionary != null) {
      question = Question(questionDictionary);
    }
  }

  Map<String, dynamic> questionLinkDictionary() {
    return {
      Keys().question: ParsableObject.tryGetDict(question),
      Keys().questionId: questionId
    };
  }

}
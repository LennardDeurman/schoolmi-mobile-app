import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/network/models/abstract/base.dart';

class TaggingPreferencesWithQuestionParent {

  bool followUpperQuestion;

  void parseQuestionParentPreferences(Map<String, dynamic> dictionary) {
    followUpperQuestion = ParsableObject.parseBool(dictionary[Keys().followUpperQuestion]);
  }

  Map<String, dynamic> questionParentPreferencesDict() {
    return {
      Keys().followUpperQuestion: followUpperQuestion
    };
  }

}

class TaggingPreferencesWithAnswerParent {

  bool followUpperAnswer;

  void parseAnswerParentPreferences(Map<String, dynamic> dictionary) {
    followUpperAnswer = ParsableObject.parseBool(dictionary[Keys().followUpperAnswer]);
  }

  Map<String, dynamic> answerParentPreferencesDict() {
    return {
      Keys().followUpperAnswer: followUpperAnswer
    };
  }

}

class TaggingPreferences extends ParsableObject {

  bool followSelf;

  TaggingPreferences (Map<String, dynamic> map) {
    parse(map);
  }

  @override
  Map<String, dynamic> toDictionary() {
    return {
      Keys().followSelf: followSelf
    };
  }

  @override
  void parse(Map<String, dynamic> dictionary) {
    followSelf = ParsableObject.parseBool(dictionary[Keys().followSelf]);
  }
}

class AnswerCommentTaggingPreferences extends TaggingPreferences with TaggingPreferencesWithAnswerParent, TaggingPreferencesWithQuestionParent {

  AnswerCommentTaggingPreferences (Map<String, dynamic> map) : super(map);

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    parseAnswerParentPreferences(dictionary);
    parseQuestionParentPreferences(dictionary);
  }

  @override
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> superDict = super.toDictionary();
    superDict.addAll(answerParentPreferencesDict());
    superDict.addAll(questionParentPreferencesDict());
    return superDict;
  }

}

class QuestionCommentTaggingPreferences extends TaggingPreferences with TaggingPreferencesWithQuestionParent {

  QuestionCommentTaggingPreferences (Map<String, dynamic> map): super(map);

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    parseQuestionParentPreferences(dictionary);
  }

  @override
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> superDict = super.toDictionary();
    superDict.addAll(questionParentPreferencesDict());
    return superDict;
  }

}

class AnswerTaggingPreferences extends TaggingPreferences with TaggingPreferencesWithQuestionParent {

  AnswerTaggingPreferences (Map<String, dynamic> map) : super(map);

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    parseQuestionParentPreferences(dictionary);
  }

  @override
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> superDict = super.toDictionary();
    superDict.addAll(questionParentPreferencesDict());
    return superDict;
  }

}
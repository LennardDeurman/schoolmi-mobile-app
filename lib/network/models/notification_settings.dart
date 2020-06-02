import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/keys.dart';

class DataNotificationPreferences extends ParsableObject {

  bool enabled;
  List<int> tagIds;

  DataNotificationPreferences (Map<String, dynamic> map) {
    parse(map);
  }

  @override
  Map<String, dynamic> toDictionary() {
    return {
      Keys().enabled: enabled,
      Keys().tagIds: tagIds
    };
  }

  @override
  void parse(Map<String, dynamic> dictionary) {
    enabled = ParsableObject.parseBool(dictionary[Keys().enabled]);
    tagIds = dictionary[Keys().tagIds] ?? [];
  }

}

class EventPreferences extends ParsableObject {

  bool deleted;
  bool edited;
  bool flagged;
  bool voted;

  EventPreferences (Map<String, dynamic> map) {
    parse(map);
  }

  @override
  Map<String, dynamic> toDictionary() {
    return {
      Keys().deleted: deleted,
      Keys().edited: edited,
      Keys().flagged: flagged,
      Keys().voted: voted
    };
  }

  @override
  void parse(Map<String, dynamic> dictionary) {
    deleted = ParsableObject.parseBool(dictionary[Keys().deleted]);
    edited = ParsableObject.parseBool(dictionary[Keys().edited]);
    flagged = ParsableObject.parseBool(dictionary[Keys().flagged]);
    voted = ParsableObject.parseBool(dictionary[Keys().voted]);
  }

}

class EventPreferencesWithCommentChild {

  bool editedComment;
  bool newComment;

  void parseCommentPreferences(Map<String, dynamic> map) {
    editedComment = ParsableObject.parseBool(map[Keys().editedComment]);
    newComment = ParsableObject.parseBool(map[Keys().newComment]);
  }

  Map<String, dynamic> commentPreferencesDict() {
    return {
      Keys().editedComment: editedComment,
      Keys().newComment: newComment
    };
  }

}

class AnswerEventPreferences extends EventPreferences with EventPreferencesWithCommentChild {

  AnswerEventPreferences (Map<String, dynamic> map) : super(map);

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    parseCommentPreferences(dictionary);
  }

  @override
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = super.toDictionary();
    map.addAll(commentPreferencesDict());
    return map;
  }

}

class QuestionEventPreferences extends EventPreferences with EventPreferencesWithCommentChild {

  bool flaggedDuplicate;

  QuestionEventPreferences (Map<String, dynamic> map) : super(map);

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    parseCommentPreferences(dictionary);
    flaggedDuplicate = ParsableObject.parseBool(dictionary[Keys().flaggedDuplicate]);
  }

  @override
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = super.toDictionary();
    map.addAll(commentPreferencesDict());
    map[Keys().flaggedDuplicate] = flaggedDuplicate;
    return map;
  }

}

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


class NotificationSettings extends ParsableObject {


  bool autoFollowQuestions;
  bool autoFollowAnswers;
  bool autoFollowComments;
  bool autoFollowQuestionsOnComment;
  bool autoFollowQuestionsOnAnswer;
  bool autoFollowAnswersOnComment;
  bool autoFollowQuestionsOnAnswerComment;

  bool sendNewMembersNotification;
  bool sendNotificationMyMemberInfoUpdated;

  DataNotificationPreferences dataNotificationPreferences;

  QuestionEventPreferences questionEventPreferences;
  AnswerEventPreferences answerEventPreferences;
  EventPreferences commentEventPreferences;

  TaggingPreferences questionTaggingPreferences;
  AnswerTaggingPreferences answerTaggingPreferences;
  QuestionCommentTaggingPreferences questionCommentTaggingPreferences;
  AnswerCommentTaggingPreferences answerCommentTaggingPreferences;

  NotificationSettings (Map<String, dynamic> map) {
    parse(map);
  }

  @override
  Map<String, dynamic> toDictionary() {
    return {
      Keys().autoFollowQuestions: autoFollowQuestions,
      Keys().autoFollowAnswers: autoFollowAnswers,
      Keys().autoFollowComments: autoFollowComments,
      Keys().autoFollowQuestionsOnComment: autoFollowQuestionsOnComment,
      Keys().autoFollowQuestionsOnAnswer: autoFollowQuestionsOnAnswer,
      Keys().autoFollowQuestionsOnAnswerComment: autoFollowQuestionsOnAnswerComment,
      Keys().autoFollowAnswersOnComment: autoFollowAnswersOnComment,
      Keys().sendNewMembersNotification: sendNewMembersNotification,
      Keys().sendNotificationMyMemberInfoUpdated: sendNotificationMyMemberInfoUpdated,
      Keys().sendNewDataNotification: ParsableObject.tryGetDict(dataNotificationPreferences),
      Keys().questionEventPreferences: ParsableObject.tryGetDict(questionEventPreferences),
      Keys().answerEventPreferences: ParsableObject.tryGetDict(answerEventPreferences),
      Keys().commentEventPreferences: ParsableObject.tryGetDict(commentEventPreferences),
      Keys().questionTaggingPreferences: ParsableObject.tryGetDict(questionTaggingPreferences),
      Keys().answerTaggingPreferences: ParsableObject.tryGetDict(answerTaggingPreferences),
      Keys().questionCommentTaggingPreferences: ParsableObject.tryGetDict(questionCommentTaggingPreferences),
      Keys().answerCommentTaggingPreferences: ParsableObject.tryGetDict(answerTaggingPreferences)
    };
  }

  @override
  void parse(Map<String, dynamic> dictionary) {
      autoFollowQuestions = ParsableObject.parseBool(dictionary[Keys().autoFollowQuestions]);
      autoFollowAnswers = ParsableObject.parseBool(dictionary[Keys().autoFollowAnswers]);
      autoFollowComments = ParsableObject.parseBool(dictionary[Keys().autoFollowComments]);
      autoFollowQuestionsOnComment = ParsableObject.parseBool(dictionary[Keys().autoFollowQuestionsOnComment]);
      autoFollowQuestionsOnAnswer = ParsableObject.parseBool(dictionary[Keys().autoFollowQuestionsOnAnswer]);
      autoFollowQuestionsOnAnswerComment = ParsableObject.parseBool(dictionary[Keys().autoFollowQuestionsOnAnswerComment]);
      autoFollowAnswersOnComment = ParsableObject.parseBool(dictionary[Keys().autoFollowAnswersOnComment]);
      sendNewMembersNotification = ParsableObject.parseBool(dictionary[Keys().sendNewMembersNotification]);
      sendNotificationMyMemberInfoUpdated = ParsableObject.parseBool(dictionary[Keys().sendNotificationMyMemberInfoUpdated]);

      dataNotificationPreferences = ParsableObject.parseObject(
          dictionary[Keys().sendNewDataNotification],
          objectCreator: (Map<String, dynamic> map) {
            return DataNotificationPreferences(map);
          }
      );

      questionEventPreferences = ParsableObject.parseObject(
        dictionary[Keys().questionEventPreferences],
        objectCreator: (Map<String, dynamic> map) {
          return QuestionEventPreferences(map);
        }
      );

      answerEventPreferences = ParsableObject.parseObject(
          dictionary[Keys().answerEventPreferences],
          objectCreator: (Map<String, dynamic> map) {
            return AnswerEventPreferences(map);
          }
      );

      commentEventPreferences = ParsableObject.parseObject(
          dictionary[Keys().commentEventPreferences],
          objectCreator: (Map<String, dynamic> map) {
            return EventPreferences(map);
          }
      );

      questionTaggingPreferences = ParsableObject.parseObject(
          dictionary[Keys().questionTaggingPreferences],
          objectCreator: (Map<String, dynamic> map) {
            return TaggingPreferences(map);
          }
      );

      answerTaggingPreferences = ParsableObject.parseObject(
          dictionary[Keys().answerTaggingPreferences],
          objectCreator: (Map<String, dynamic> map) {
            return AnswerTaggingPreferences(map);
          }
      );

      questionCommentTaggingPreferences = ParsableObject.parseObject(
          dictionary[Keys().questionCommentTaggingPreferences],
          objectCreator: (Map<String, dynamic> map) {
            return QuestionCommentTaggingPreferences(map);
          }
      );

      answerCommentTaggingPreferences = ParsableObject.parseObject(
          dictionary[Keys().answerCommentTaggingPreferences],
          objectCreator: (Map<String, dynamic> map) {
            return AnswerCommentTaggingPreferences(map);
          }
      );

  }


}
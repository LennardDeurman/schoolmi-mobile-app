import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/models/settings/event_preferences.dart';
import 'package:schoolmi/network/models/settings/tagging_preferences.dart';
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
import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/network/models/abstract/base.dart';


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
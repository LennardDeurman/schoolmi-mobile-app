import 'package:schoolmi/models/data/answer.dart';
import 'package:schoolmi/models/data/comment.dart';
import 'package:schoolmi/models/data/extensions/object_with_flags.dart';
import 'package:schoolmi/models/data/question.dart';
import 'package:schoolmi/network/api.dart';
import 'package:scoped_model/scoped_model.dart';

class FlagManager extends Model {

  int _questionId = 0;
  int _answerId = 0;
  int _commentId = 0;

  ObjectWithFlags _object;

  FlagManager.forQuestion (Question question) {
    _object = question;
    _questionId = question.id;
  }

  FlagManager.forAnswer (Answer answer) {
    _object = answer;
    _questionId = answer.questionId;
    _answerId = answer.id;
  }

  FlagManager.forComment (Comment comment, { Answer answer, Question question }) {
    _object = comment;
    _commentId = comment.id;
    if (answer != null) {
      _answerId = answer.id;
    }
    if (question != null) {
      _questionId = question.id;
    }
  }

  void bindEvents(Model parentModel) {  //When an event is called within this model, the parent notify is called
    addListener(() {
      parentModel.notifyListeners();
    });
  }

  void updateFlagStatus(bool flaggedByMe, { Function onError }) {
    _object.flaggedByMe = flaggedByMe;
    notifyListeners();
    Api.updateFlagStatus(questionId: _questionId, answerId: _answerId, commentId: _commentId, flagged: flaggedByMe).catchError((e) {
      _object.flaggedByMe = !_object.flaggedByMe;
      if (onError != null) {
        onError();
      }
      notifyListeners();
    });
  }




}
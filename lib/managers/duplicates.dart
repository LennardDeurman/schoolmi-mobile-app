import 'dart:async';
import 'package:schoolmi/managers/search_questions.dart';
import 'package:schoolmi/managers/view_question.dart';
import 'package:schoolmi/models/data/duplicate_question.dart';
import 'package:schoolmi/models/data/profile.dart';
import 'package:schoolmi/models/data/question.dart';
import 'package:schoolmi/network/api.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/network/duplicates_api.dart';
import 'package:scoped_model/scoped_model.dart';

class SearchQuestionsForDuplicatesManager extends SearchQuestionsManager {

  final ViewQuestionManager viewQuestionManager;

  DuplicatesUpdater _updater;

  SearchQuestionsForDuplicatesManager (this.viewQuestionManager) : super(viewQuestionManager.homeManager) {
    _updater = DuplicatesUpdater(viewQuestionManager);
  }


  Future<List<DuplicateQuestion>> duplicatedQuestionsReportedByMe() async {
    String uid = await Api.getMyUid();
    return viewQuestionManager.question.duplicateQuestions.where((DuplicateQuestion duplicateQuestion) {
      List<String> uidsList = duplicateQuestion.reporters.map((profile) {
        return profile.firebaseUid;
      }).toList();
      return uidsList.contains(uid);
    }).toList();
  }

  Future updateDuplicatesReportedByMe(List<Question> myNewDuplicates) async {
    return _updater.updateMyDuplicates(myNewDuplicates);
  }

  @override
  Future fetchPreLoadedData() async {
    questionSelectionManager.objects = List<Question>();
    List<Question> duplicateQuestions = await duplicatedQuestionsReportedByMe();
    for (Question question in duplicateQuestions) {
      questionSelectionManager.objects.add(Question(question.dictionary));
    }
  }

}

class DuplicatesUpdater extends Model {

  final ViewQuestionManager viewQuestionManager;

  DuplicatesApi _duplicatesApi;

  List<Map<String, dynamic>> _updateMap = new List<Map<String, dynamic>>();
  List<Question> _newQuestions = new List<Question>();
  List<DuplicateQuestion> _oldDuplicatesByMe = new List<DuplicateQuestion>();
  List<DuplicateQuestion> _oldDuplicateQuestions = new List<DuplicateQuestion>();
  List<DuplicateQuestion> _removedDuplicatesQuestions = new List<DuplicateQuestion>();
  String _myUid;

  DuplicatesUpdater (this.viewQuestionManager) {
    _duplicatesApi = DuplicatesApi(viewQuestionManager.question);
  }

  void _initialize() {
    _updateMap = new List<Map<String, dynamic>>();
    _newQuestions = new List<Question>();
    _oldDuplicatesByMe = new List<DuplicateQuestion>();
    _removedDuplicatesQuestions = new List<DuplicateQuestion>();
    _oldDuplicateQuestions = viewQuestionManager.question.duplicateQuestions;
  }

  void _updateData() {
    Question question = viewQuestionManager.question;
    for (DuplicateQuestion duplicateQuestion in _removedDuplicatesQuestions) {
      if (duplicateQuestion.reporters.length > 1) {
        duplicateQuestion.reporters.removeWhere((Profile profile) {
          return profile.firebaseUid == _myUid;
        });
      } else { //Its only the user that has just deleted it
        question.duplicateQuestions.remove(duplicateQuestion);
      }
    }

    //Add duplicateQuestions
    List<DuplicateQuestion> newDuplicateQuestions = new List<DuplicateQuestion>();
    for (Question newQuestion in _newQuestions) {
      DuplicateQuestion duplicateQuestion = DuplicateQuestion(newQuestion.dictionary);
      int indexOf = question.duplicateQuestions.indexOf(duplicateQuestion);
      if (indexOf > -1) {
        duplicateQuestion = question.duplicateQuestions[indexOf];
        duplicateQuestion.reporters.add(UserService().loginResult.profile);
      } else {
        duplicateQuestion.reporters.add(UserService().loginResult.profile);
        newDuplicateQuestions.add(duplicateQuestion);
      }
    }
    question.duplicateQuestions.addAll(newDuplicateQuestions);
  }

  Future updateMyDuplicates(List<Question> myNewDuplicates) async {
    Completer completer = Completer();

    try {
      _initialize();
      _myUid = await Api.getMyUid();
      _oldDuplicatesByMe = await viewQuestionManager.duplicatesManager.duplicatedQuestionsReportedByMe();
      _newQuestions = myNewDuplicates;

      _oldDuplicatesByMe.forEach((DuplicateQuestion duplicateQuestion) {
        if (!_newQuestions.contains(duplicateQuestion)) {
          _updateMap.add(_duplicatesApi.makeDuplicateMap(
              duplicateOfQuestionId: duplicateQuestion.id,
              isDeleted: true
          ));
          _removedDuplicatesQuestions.add(duplicateQuestion);
        }
      });

      for (Question duplicateQuestion in _newQuestions) {
        _updateMap.add(_duplicatesApi.makeDuplicateMap(
            duplicateOfQuestionId: duplicateQuestion.id,
            isDeleted: false
        ));
      }


      _updateData();
      notifyListeners();

      await _duplicatesApi.updateDuplicateQuestions(
          duplicatesMapList: _updateMap
      );

      completer.complete();
    } catch (e) {
      viewQuestionManager.question.duplicateQuestions = _oldDuplicateQuestions;
      notifyListeners();
      completer.completeError(e);
    }

    return completer.future;
  }


}
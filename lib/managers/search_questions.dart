import 'package:schoolmi/managers/child_manager.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/managers/selection.dart';
import 'package:schoolmi/models/data/question.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/network/parsers/questions.dart';

abstract class SearchQuestionsManager extends ChildManager {

  SelectionManager questionSelectionManager;

  QuestionsParser questionsParser;

  SearchQuestionsManager (HomeManager homeManager) : super(homeManager) {
    questionSelectionManager = SelectionManager<Question>();
    questionsParser = QuestionsParser(UserService().loginResult.activeChannel);
  }

  Future fetchPreLoadedData();

}


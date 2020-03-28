import 'dart:async';
import 'package:schoolmi/managers/duplicates.dart';
import 'package:schoolmi/managers/flag.dart';
import 'package:schoolmi/managers/votes.dart';
import 'package:schoolmi/models/parsing_result.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/network/parsers/answers.dart';
import 'package:schoolmi/network/parsers/duplicates.dart';
import 'package:schoolmi/network/parsers/questions.dart';
import 'package:schoolmi/models/data/answer.dart';
import 'package:schoolmi/models/data/duplicate_question.dart';
import 'package:schoolmi/managers/child_manager.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:flutter/material.dart';
import 'package:schoolmi/models/data/question.dart';

class ViewQuestionManager extends ChildManager {

  QuestionsParser questionsParser;
  AnswerParser answerParser;
  DuplicatesParser duplicatesParser;
  VotesManager votesManager;
  SearchQuestionsForDuplicatesManager duplicatesManager;

  Question question;

  ViewQuestionManager (HomeManager homeManager, { @required this.question }) : super(homeManager) {
    answerParser = AnswerParser(
        UserService().loginResult.activeChannel,
        questionId: question.id
    );
    questionsParser = QuestionsParser(
        UserService().loginResult.activeChannel,
        questionId: question.id
    );
    duplicatesParser = DuplicatesParser(
        UserService().loginResult.activeChannel,
        question.id
    );
    duplicatesManager = SearchQuestionsForDuplicatesManager(this);
    votesManager = VotesManager();
    votesManager.bindEvents(this);
  }


  Future loadQuestion() {
    return questionsParser.download().then((ParsingResult result) {
      Question newQuestion = result.object;
      question.parse(newQuestion.dictionary);
    });
  }

  Future loadAnswers() {
    return answerParser.download().then((ParsingResult result) {
      List<Answer> answers = List<Answer>();
      for (Answer answer in result.objects) {
        answers.add(answer);
      }
      question.answers = answers;
    });
  }

  Future loadDuplicates() {
    return duplicatesParser.download().then((ParsingResult result) {
      List<DuplicateQuestion> duplicateQuestions = List<DuplicateQuestion>();
      for (DuplicateQuestion duplicateQuestion in result.objects) {
        duplicateQuestions.add(duplicateQuestion);
      }
      question.duplicateQuestions = duplicateQuestions;
    });
  }


  Future refreshAllData() {
    Future questionFuture = executeAsync(loadQuestion());
    Future answersFuture = executeAsync(loadAnswers());
    Future duplicatesFuture = executeAsync(loadDuplicates());
    return Future.wait([questionFuture, answersFuture, duplicatesFuture]);
  }

  Future undoDelete() {
    question.isDeleted = false;
    notifyListeners();
    return questionsParser.uploadObject(question);
  }

  Future undoDeleteAnswer(Answer answer) {
    answer.isDeleted = false;
    notifyListeners();
    return answerParser.uploadObject(answer);
  }

  Future markAnswerSelected(Answer answer) {
    int oldSelectionAnswer = question.answerId;
    question.answerId = answer.id;
    notifyListeners();
    return questionsParser.uploadObject(question).catchError((e) {
      question.answerId = oldSelectionAnswer;
      notifyListeners();
    });
  }



}
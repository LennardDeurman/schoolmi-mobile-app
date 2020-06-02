import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/managers/view_question.dart';
import 'package:schoolmi/models/data/duplicate_question.dart';
import 'package:schoolmi/models/data/question.dart';
import 'package:schoolmi/network/api.dart';
import 'package:schoolmi/widgets/alerts/snackbar.dart';
import 'package:schoolmi/widgets/cells/duplicate_question.dart';
import 'package:schoolmi/widgets/listviews/parser_listview.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:flutter/material.dart';
import 'package:schoolmi/widgets/presenter.dart';
import 'package:schoolmi/widgets/users/static_users_sheet.dart';
import 'package:schoolmi/widgets/users/users_sheet.dart';

class DuplicateQuestionsListView extends ParserListView {

  final ViewQuestionManager manager;

  DuplicateQuestionsListView (this.manager) : super(manager.duplicatesParser);

  @override
  State<StatefulWidget> createState() {
    return _DuplicateQuestionsListView();
  }

}

class _DuplicateQuestionsListView extends ParserListViewState<DuplicateQuestionsListView> {

  Presenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = new Presenter(context);
  }

  void _updateDuplicatedFlag() {
    widget.manager.question.duplicated = parsingResult.objects.length > 0; //If there are duplicates, then it's duplicated
    if (!widget.manager.question.duplicated) {
      widget.manager.question.flaggedDuplicateByMe = false;
    }
  }

  void _showReporters(DuplicateQuestion question) {
    UsersSheet.showUsers(context: context, profiles: question.reporters);
  }

  void _showQuestion(Question question) {
    _presenter.showQuestion(widget.manager.homeManager, question);
  }

  void _deleteMarking(DuplicateQuestion question) async {
    setState(() {
      parsingResult.objects.remove(question);
    });
    _updateDuplicatedFlag();

    Api.removeAllMarkings(widget.manager.question, question).catchError((e) {
      setState(() {
        parsingResult.objects.add(question);
      });
      _updateDuplicatedFlag();
      showSnackBar(message: Localization().getValue(Localization().errorUnexpected), isError: true, buildContext: context);
    });

  }


  @override
  Widget buildListItem(BaseObject object) {
    return DuplicateQuestionCell(
      object,
      showQuestion: _showQuestion,
      deleteMarking: _deleteMarking,
      showReporters: _showReporters,
    );
  }

}
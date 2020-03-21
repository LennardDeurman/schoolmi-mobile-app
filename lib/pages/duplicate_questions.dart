import 'package:flutter/material.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/managers/view_question.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/widgets/listviews/duplicate_questions.dart';

class DuplicateQuestionsPage extends StatefulWidget {

  final ViewQuestionManager viewQuestionManager;

  DuplicateQuestionsPage (this.viewQuestionManager);

  @override
  State<StatefulWidget> createState() {
    return _DuplicateQuestionsPage();
  }

}

class _DuplicateQuestionsPage extends State<DuplicateQuestionsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleLabel(
          title: Localization().getValue(Localization().duplicatedQuestions),
          color: Colors.white,
        )
      ),
      body: DuplicateQuestionsListView(this.widget.viewQuestionManager),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/managers/search_questions.dart';
import 'package:schoolmi/models/data/question.dart';
import 'package:schoolmi/widgets/bottom_bar.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/widgets/listviews/search_questions.dart';



class SearchQuestionsPage extends StatefulWidget {

  final SearchQuestionsManager manager;
  final Function(List<Question> questions) onQuestionsSelected;

  SearchQuestionsPage (this.manager, { this.onQuestionsSelected });

  @override
  State<StatefulWidget> createState() {
    return _SearchQuestionsPageState();
  }

  static void show({ BuildContext context, Function(List<Question> questions) onQuestionsSelected, SearchQuestionsManager manager }) {
    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
      return SearchQuestionsPage(manager, onQuestionsSelected: onQuestionsSelected);
    }));
  }

}

class _SearchQuestionsPageState extends State<SearchQuestionsPage> {

  void _onCancelPressed(BuildContext context) {
    Navigator.pop(context);
  }

  void _onConfirmPressed(BuildContext context) {
    Navigator.pop(context);

    if (this.widget.onQuestionsSelected != null) {
      this.widget.onQuestionsSelected(widget.manager.questionSelectionManager.objects);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TitleLabel(
            title: Localization().getValue(Localization().searchQuestions),
            color: Colors.white,
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: SearchQuestionsListView(widget.manager)
            ),
            SafeArea(
              child: BottomBar(
                onCancelPressed: () {
                  _onCancelPressed(context);
                },
                onConfirmPressed: () {
                  _onConfirmPressed(context);
                },
              ),
            )
          ],
        )
    );
  }

}



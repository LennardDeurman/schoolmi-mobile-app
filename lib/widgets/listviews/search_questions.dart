import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/managers/search_questions.dart';
import 'package:schoolmi/models/data/question.dart';
import 'package:schoolmi/widgets/listviews/parser_listview.dart';
import 'package:schoolmi/widgets/listviews/search_listview.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:flutter/material.dart';

class SearchQuestionsListView extends ParserListView {

  final SearchQuestionsManager manager;

  SearchQuestionsListView (this.manager) : super(manager.questionsParser);

  @override
  State<StatefulWidget> createState() {
    return _SearchQuestionsListViewState();
  }

}

class _SearchQuestionsListViewState extends SearchListViewState<SearchQuestionsListView> {

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    widget.manager.fetchPreLoadedData().then((_) {
      setState(() {
      });
    });
  }


  @override
  Widget buildListItem(BaseObject object) {
    Question question = object;
    return Container(child:
      Material(child:
        InkWell(
          child: Container(
            child: ListTile(
              title: Text(question.title),
              trailing: widget.manager.questionSelectionManager.objects.contains(question) ? Icon(Icons.check_circle, color: Colors.green)
                  : Icon(Icons.radio_button_unchecked),
            ),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1,
                        color: BrandColors.blueGrey
                    )
                )
            ),
          ),
          onTap: () {
            setState(() {
              widget.manager.questionSelectionManager.toggle(question);
            });
          },
        ),
        color: Colors.white,
      )
    );
  }

  @override
  void onChangedSearchField(String value) {
    performSearch(value);
  }


}
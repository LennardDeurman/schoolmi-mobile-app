import 'package:schoolmi/widgets/listviews/parser_listview.dart';
import 'package:schoolmi/widgets/request_options_bar.dart';
import 'package:schoolmi/network/parsers/questions.dart';
import 'package:schoolmi/models/options.dart';
import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/models/data/question.dart';
import 'package:schoolmi/widgets/cells/question.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:flutter/material.dart';

class QuestionsListView extends ParserListView  {

  final Function (Question) onQuestionPressed;

  QuestionsListView (QuestionsParser parser, { @required this.onQuestionPressed  }) : super(parser);

  @override
  State<StatefulWidget> createState() {
    return QuestionsListViewState();
  }

}

class QuestionsListViewState extends ParserListViewState<QuestionsListView> {

  @override
  Widget build(BuildContext context) {
    return Container(
        color: BrandColors.blueGrey,
        child: Column(
          children: <Widget>[
            Container(
              child: RequestOptionsBar(
                  filterOptionsBox,
                  orderOptionsBox,
                  onOptionsChanged: () async {
                    refreshIndicatorKey.currentState.show();
                    parsingResult = await widget.parser.download();
                  }
              ),
            ),
            Expanded(
                child: buildRefreshWidget()
            )
          ],
        )
    );
  }

  @override
  Widget buildListItem(BaseObject object) {
    Question question = object;
    return QuestionCell(
      question: question,
      onPressed: (Question question) {
        widget.onQuestionPressed(question);
      },
    );
  }


  OptionsBox get filterOptionsBox {
    OptionsBox filterOptionsBox = OptionsBox.fromMap({
      Localization().getValue(Localization().allQuestions): 1,
      Localization().getValue(Localization().onlyNewQuestions): 2,
      Localization().getValue(Localization().updatedQuestions): 5,
      Localization().getValue(Localization().unansweredQuestions): 4
    });
    return filterOptionsBox;
  }

  OptionsBox get orderOptionsBox {
    OptionsBox orderOptionsBox = OptionsBox.fromMap({
      Localization().getValue(Localization().orderDateModified): 1,
      Localization().getValue(Localization().orderDateAdded): 2,
      Localization().getValue(Localization().orderVotes): 3
    });
    orderOptionsBox.name = Localization().getValue(Localization().order);
    return orderOptionsBox;
  }




}
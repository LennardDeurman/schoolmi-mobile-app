import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/network/query_info.dart';
import 'package:schoolmi/widgets/listviews/parser_listview.dart';
import 'package:schoolmi/widgets/options/request_options_bar.dart';
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

  QuestionsListView (QuestionsParser parser, { @required this.onQuestionPressed, Key key  }) : super(parser, key: key);

  @override
  State<StatefulWidget> createState() {
    return QuestionsListViewState();
  }

}

class QuestionsListViewState extends ParserListViewState<QuestionsListView> {

  int orderIndex = 0;
  int filterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: <Widget>[
            Container(
              child: RequestOptionsBar(
                  filterOptionsBox,
                  orderOptionsBox,
                  onOptionsChanged: ({int orderIndex, int filterIndex }) async {
                    this.orderIndex = orderIndex;
                    this.filterIndex = filterIndex;

                    QuestionsParser parser = widget.parser;
                    parser.queryInfo = new QueryInfo(
                      order: orderOptionsBox.value.value,
                      filter: filterOptionsBox.value.value
                    );
                    refreshIndicatorKey.currentState.show();
                  }
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
    if (UserService().loginResult.activeChannel.isUserAdmin) {
      filterOptionsBox.addOption(Option(Localization().getValue(Localization().flaggedQuestions), 3));
      filterOptionsBox.addOption(Option(Localization().getValue(Localization().deletedQuestions), 6));
    }
    filterOptionsBox.selectedIndex = filterIndex;
    return filterOptionsBox;
  }

  OptionsBox get orderOptionsBox {
    OptionsBox orderOptionsBox = OptionsBox.fromMap({
      Localization().getValue(Localization().orderDateModified): 1,
      Localization().getValue(Localization().orderDateAdded): 2,
      Localization().getValue(Localization().orderVotes): 3
    });
    orderOptionsBox.name = Localization().getValue(Localization().order);
    orderOptionsBox.selectedIndex = orderIndex;
    return orderOptionsBox;
  }







}
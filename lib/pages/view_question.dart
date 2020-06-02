import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/managers/view_question.dart';
import 'package:schoolmi/models/data/question.dart';
import 'package:schoolmi/network/models/options.dart';
import 'package:schoolmi/widgets/content/answer_details_block.dart';
import 'package:schoolmi/widgets/content/question_details_block.dart';
import 'package:schoolmi/widgets/listviews/advanced_listview.dart';
import 'package:schoolmi/widgets/options/filter_options_bar.dart';
import 'package:schoolmi/widgets/options/filter_options_bottomsheet.dart';
import 'package:scoped_model/scoped_model.dart';

class ViewQuestionPage extends StatefulWidget {

  final Question question;
  final HomeManager homeManager;

  ViewQuestionPage (this.question, { this.homeManager });

  @override
  State<StatefulWidget> createState() {
    return _ViewQuestionPageState();
  }

}



class _ViewQuestionPageState extends State<ViewQuestionPage> {

  ViewQuestionManager _viewQuestionManager;
  OptionsBox _answerOrderOptionsBox;
  AnswersFilterOptionsManager _answerOptionsManager;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _viewQuestionManager = ViewQuestionManager(widget.homeManager, question: widget.question);
    _answerOrderOptionsBox = OptionsBox.fromMap({
      Localization().getValue(Localization().orderDateModified): 1,
      Localization().getValue(Localization().orderDateAdded): 2,
      Localization().getValue(Localization().orderVotes): 3
    });

    _answerOrderOptionsBox.name = Localization().getValue(Localization().order);
    _answerOrderOptionsBox.selectedIndex = 1;

    _answerOptionsManager = AnswersFilterOptionsManager();

    WidgetsBinding.instance.addPostFrameCallback( ( Duration duration ) {
      this._refreshIndicatorKey.currentState.show();
    } );
  }

  Future _onRefresh() {
    return _viewQuestionManager.refreshAllData();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(child: Scaffold(
      backgroundColor: BrandColors.blueGrey,
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        key: _refreshIndicatorKey,
        child: ScopedModelDescendant(
          builder: (BuildContext context, Widget widget, ViewQuestionManager manager) {
            return AdvancedListView.withSections(
                listViewSections: [
                  ListViewSection(
                    itemBuilder: (int rowIndex) {
                      return Container(
                        child: QuestionDetailsBlock(_viewQuestionManager),
                        margin: EdgeInsets.only(
                          bottom: 20
                        ),
                      );
                    },
                  ),
                  ListViewSection(
                      itemBuilder: (int rowIndex) {
                        return Container(
                          child: AnswerDetailsBlock(
                              _viewQuestionManager,
                              _viewQuestionManager.question.answers[rowIndex]
                          ),
                          margin: EdgeInsets.only(
                            bottom: 20
                          ),
                        );
                      },
                      headerBuilder: () {
                        return FilterOptionsBar(
                            typesOptionsBox: OptionsBox.fromMap({
                              Localization().buildNumberAndText(Localization().answers, count: _viewQuestionManager.question.answers.length): 1
                            }),
                            orderOptionsBox: _answerOrderOptionsBox,
                            optionsManagerBuilder: () {
                              AnswersFilterOptionsManager filterManager = AnswersFilterOptionsManager();
                              filterManager.copy(_answerOptionsManager);
                              return filterManager;
                            },
                            onApplyPressed: (BuildContext context, FilterOptionsManager manager) {
                              this._answerOptionsManager.copy(manager);
                            },
                            shouldRefresh: () {

                            },
                        );
                      },
                      numberOfRows: _viewQuestionManager.question.answers.length
                  )
                ]
            );
          }
        )

      ),
    ), model: _viewQuestionManager);
  }

}
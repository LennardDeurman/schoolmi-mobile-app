
import 'package:schoolmi/managers/view_question.dart';
import 'package:schoolmi/widgets/content/content_actions_bar.dart';
import 'package:schoolmi/widgets/content/details_block.dart';
import 'package:flutter/material.dart';
import 'package:schoolmi/models/data/answer.dart';
import 'package:schoolmi/widgets/highlighted_widget.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/widgets/content/report_button.dart';
import 'package:schoolmi/widgets/content/warning.dart';
import 'package:schoolmi/widgets/content/attachments.dart';
import 'package:schoolmi/widgets/content/votes.dart';
import 'package:schoolmi/extensions/dates.dart';

class AnswerDetailsBlock extends DetailsBlock {

  final Answer answer;

  AnswerDetailsBlock (ViewQuestionManager manager, this.answer) : super(manager);

  void _answerUndoDeleted() {

  }

  void _onVoteStateChanged(int newVoteState) {

  }

  void _markAcceptedAnswer() {

  }

  void _onReportPressed() {

  }

  void _onCommentsPressed() {

  }

  void _onEditPressed() {

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: DetailsBlock.defaultBoxDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Warning.answerMarkedDeleted(answer, onPressed: _answerUndoDeleted),
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Votes(
                      answer.votesInfo,
                      onVoteStateChanged: _onVoteStateChanged,
                    ),
                    HighlightedIcon(iconData: Icons.check_circle_outline, selected: manager.question.isSelectedAnswer(answer), onPressed: _markAcceptedAnswer)
                  ],
                ),
                Expanded(child: Container(
                  margin: EdgeInsets.only(
                    left: 20
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          RegularLabel(
                            title: Dates.format(answer.dateAdded),
                            size: LabelSize.small,
                            font: LabelFont.montserrat,
                          ),
                          Spacer(),
                          ReportButton(onPressed: _onReportPressed, flaggedByMe: answer.flaggedByMe)
                        ],
                      ),
                      Container(
                        child: RegularLabel(title: answer.body),
                        padding: EdgeInsets.symmetric(vertical: 20),
                      ),
                      AttachmentsContainer(attachments: answer.attachments),
                      DetailsBlock.buildLowerContainer(profile: answer.profile, commentsCount: answer.commentsCount, onCommentsPressed: _onCommentsPressed)
                    ],
                  ),
                ))
              ],
            ),
          ),
          ContentActionsBar (
            onEditPressed: _onEditPressed,
            onReplyPressed: _onCommentsPressed,
          )
        ],
      ),
    );
  }

}
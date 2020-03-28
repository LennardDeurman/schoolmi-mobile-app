
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/managers/flag.dart';
import 'package:schoolmi/managers/view_question.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/widgets/alerts/snackbar.dart';
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
import 'package:schoolmi/widgets/users/static_users_sheet.dart';
import 'package:schoolmi/widgets/users/users_sheet.dart';

class AnswerDetailsBlock extends DetailsBlock {

  final Answer answer;

  AnswerDetailsBlock (ViewQuestionManager manager, this.answer) : super(manager);

  @override
  bool get canEditContent {
    return UserService().loginResult.activeChannel.isUserAdmin || (answer.profile.firebaseUid == UserService().loginResult.profile.firebaseUid);
  }

  void _answerUndoDeleted(BuildContext context) {
    manager.undoDeleteAnswer(answer).catchError((e) {
      showSnackBar(message: Localization().getValue(Localization().errorUnexpected), isError: true, buildContext: context);
    });
  }

  void _onVoteStateChanged(BuildContext context, int newVoteState) {
    manager.votesManager.updateVoteInfo(answer, newVoteState, onError: () {
      showSnackBar(message: Localization().getValue(Localization().errorUnexpected), isError: true, buildContext: context);
    });
  }

  void _showReporters(BuildContext context) {
    FlagManager flagManager = FlagManager.forAnswer(answer);
    flagManager.bindEvents(manager);
    UsersSheet.showReporters(context: context, questionId: answer.questionId, answerId: answer.id, onDeleteMarkingPressed: () {
      flagManager.clearFlag(onError: () {
        showSnackBar(message: Localization().getValue(Localization().errorUnexpected), isError: true, buildContext: context);
      });
    });
  }

  void _markAcceptedAnswer(BuildContext context) {
    manager.markAnswerSelected(answer).catchError((e) {
      showSnackBar(message: Localization().getValue(Localization().errorUnexpected), isError: true, buildContext: context);
    });
  }

  void _onReportPressed(BuildContext context) {
    FlagManager flagManager = FlagManager.forAnswer(answer);
    flagManager.bindEvents(manager);
    flagManager.updateFlagStatus(!answer.flaggedByMe, onError: () {
      showSnackBar(message: Localization().getValue(Localization().errorUnexpected), isError: true, buildContext: context);
    });
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
          Container(
            margin: EdgeInsets.only(
              top: 10
            ),
            child: Column(
              children: <Widget>[
                Warning.answerMarkedFlagged(answer, onPressed: () {
                  _showReporters(context);
                }),
                Warning.answerMarkedDeleted(answer, onPressed: () {
                  _answerUndoDeleted(context);
                }),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Votes(
                          answer.votesInfo,
                          onVoteStateChanged: (newVoteState) {
                            _onVoteStateChanged(context, newVoteState);
                          },
                        ),
                        HighlightedIcon(iconData: Icons.check_circle_outline, selected: manager.question.isSelectedAnswer(answer), onPressed: () {
                          _markAcceptedAnswer(context);
                        })
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
                              ReportButton(onPressed: () {
                                _onReportPressed(context);
                              }, flaggedByMe: answer.flaggedByMe)
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
                )
              ],
            )
          ),
          ContentActionsBar (
            onEditPressed: _onEditPressed,
            onReplyPressed: _onCommentsPressed,
            canEdit: canEditContent,
          )
        ],
      ),
    );
  }

}
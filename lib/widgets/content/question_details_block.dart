import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/extensions/dates.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/models/data/question.dart';
import 'package:schoolmi/managers/view_question.dart';
import 'package:schoolmi/pages/duplicate_questions.dart';
import 'package:schoolmi/widgets/alerts/report_question.dart';
import 'package:schoolmi/widgets/alerts/snackbar.dart';
import 'package:schoolmi/widgets/content/attachments.dart';
import 'package:schoolmi/widgets/content/content_actions_bar.dart';
import 'package:schoolmi/widgets/content/details_block.dart';
import 'package:flutter/material.dart';
import 'package:schoolmi/widgets/content/report_button.dart';
import 'package:schoolmi/widgets/content/tags.dart';
import 'package:schoolmi/widgets/content/votes.dart';
import 'package:schoolmi/widgets/content/warning.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/widgets/labels/title.dart';

class QuestionDetailsBlock extends DetailsBlock {

  QuestionDetailsBlock (ViewQuestionManager manager) : super(manager);

  void _onVoteStateChanged(BuildContext context, int newVoteState) {
    manager.votesManager.updateVoteInfo(question, newVoteState, onError: () {
      showSnackBar(message: Localization().getValue(Localization().errorUnexpected), isError: true, buildContext: context);
    });
  }

  void _questionUndoDeleted(BuildContext context) {

  }

  void _showFlaggedContent(BuildContext context) {

  }

  void _showDuplicates(BuildContext context) {
    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
      return DuplicateQuestionsPage(
        this.manager
      );
    }));
  }

  void _onReportPressed(BuildContext context) {
    ReportQuestionDialog(manager).show(context);
  }

  void _onCommentsPressed(BuildContext context) {

  }

  void _onEditPressed(BuildContext context) {

  }


  BoxDecoration get upperContainerBoxDecoration {
    return BoxDecoration(
        border: Border(
            bottom: BorderSide(
                width: 1,
                color: BrandColors.blueGrey
            )
        )
    );
  }

  Question get question {
    return manager.question;
  }

  Widget _buildBodyUpperInformation() {
    return Row(
      children: <Widget>[
        RegularLabel(
          fontWeight: FontWeight.bold,
          font: LabelFont.montserrat,
          size: LabelSize.small,
          color: Colors.grey,
          title:  question.viewCount.toString(),
        ),
        SizedBox(
          width: 5,
        ),
        RegularLabel(
            fontWeight: FontWeight.w400,
            font: LabelFont.montserrat,
            size: LabelSize.small,
            title: Localization().buildNumberAndText(Localization().views, count: question.viewCount, excludeNumber: true)
        ),
        Spacer(),
        RegularLabel(
          title: Dates.format(question.dateAdded),
          size: LabelSize.small,
          font: LabelFont.montserrat,
        )
      ],
    );
  }

  Widget _buildBodyContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildBodyUpperInformation(),
          Container(
              child: RegularLabel(title: question.body),
              padding: EdgeInsets.symmetric(vertical: 20)
          ),
          AttachmentsContainer(attachments: question.attachments),
          DetailsBlock.buildLowerContainer(
            profile: question.profile,
            onCommentsPressed: () {
              _onCommentsPressed(context);
            }
          )
        ],
      ),
    );
  }

  Widget _buildHeaderContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          Votes(
            question.votesInfo,
            onVoteStateChanged: (int voteState) {
              _onVoteStateChanged(context, voteState);
            },
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: 15
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleLabel(
                  title: question.title,
                ),
                Container(
                  child: TagsContainer(
                      tags: question.tags
                  ),
                  margin: EdgeInsets.symmetric(
                      vertical: 10
                  ),
                ),
                ReportButton(
                  flaggedByMe: question.flaggedByMe,
                  onPressed: () {
                    _onReportPressed(context);
                  },
                )
              ],
            ),
          )
        ],
      ),
      decoration: upperContainerBoxDecoration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: DetailsBlock.defaultBoxDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Warning.questionMarkedDeleted(question, onPressed: () {
            _questionUndoDeleted(context);
          }),
          Warning.questionMarkedFlagged(question, onPressed: () {
            _showFlaggedContent(context);
          }),
          _buildHeaderContainer(context),
          _buildBodyContainer(context),
          Warning.questionMarkedDuplicated(question, onPressed: () {
            _showDuplicates(context);
          }),
          ContentActionsBar(
            onEditPressed: () {
              _onEditPressed(context);
            },
            onReplyPressed: () {
              _onCommentsPressed(context);
            },
          )
        ],
      ),
    );
  }

}
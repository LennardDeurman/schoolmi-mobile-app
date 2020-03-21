import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/managers/flag.dart';
import 'package:schoolmi/managers/view_question.dart';
import 'package:schoolmi/models/data/question.dart';
import 'package:schoolmi/pages/search_questions.dart';
import 'package:schoolmi/widgets/alerts/snackbar.dart';
import 'package:schoolmi/widgets/labels/regular.dart';

class ReportQuestionDialog {

  final ViewQuestionManager viewQuestionManager;


  ReportQuestionDialog(this.viewQuestionManager);

  Question get question {
    return this.viewQuestionManager.question;
  }

  Widget _buildGrabber(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      width: 50.0,
      height: 6.0,
      decoration: BoxDecoration(
        color: BrandColors.lightGrey,
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
      ),
    );
  }


  Widget _buildListItem({ BuildContext context, IconData icon, String text, bool warningVisible, String warningText, Function(BuildContext) onPressed}) {
    return FlatButton(
      onPressed: () {

        Navigator.pop(context);

        if (onPressed != null) {
          onPressed(context);
        }
      },
      child: Row(
        children: <Widget>[
          Icon(icon, color: BrandColors.lightGrey, size: 20.0),
          SizedBox(width: 10.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RegularLabel(title: text),
              Visibility(
                visible: warningVisible,
                child: RegularLabel(title: warningText, size: LabelSize.small, color: Colors.red),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMarkInappropriateQuestion(BuildContext context) {
    return _buildListItem(
      icon: FontAwesomeIcons.exclamation,
      context: context,
      text: Localization().getValue(question.flaggedByMe ?  Localization().unmark : Localization().markInappropriate),
      warningVisible: question.flaggedByMe,
      warningText: Localization().getValue(Localization().alreadyMarked),
      onPressed: _markInappropriateQuestionPressed
    );
  }

  Widget _buildMarkDuplicateQuestion(BuildContext context) {
    return _buildListItem(
      context: context,
      icon: FontAwesomeIcons.copy,
      text: Localization().getValue(Localization().markDuplicate),
      warningText: Localization().getValue(Localization().alreadyMarked),
      warningVisible: question.flaggedDuplicateByMe,
      onPressed: _markDuplicateQuestionPressed
    );
  }

  void _markDuplicateQuestionPressed(BuildContext context) {
    SearchQuestionsPage.show(
      context: context,
      manager: viewQuestionManager.duplicatesManager,
      onQuestionsSelected: (List<Question> questions) async {
        viewQuestionManager.duplicatesManager.updateDuplicatesReportedByMe(questions).catchError((e) {
          showSnackBar(message: Localization().getValue(Localization().errorUnexpected), isError: true, buildContext: context);
        });
      }
    );
  }

  void _markInappropriateQuestionPressed(BuildContext context) {
    FlagManager flagManager = FlagManager.forQuestion(question);
    flagManager.bindEvents(viewQuestionManager);
    flagManager.updateFlagStatus(!question.flaggedByMe, onError: () {
      showSnackBar(message: Localization().getValue(Localization().errorUnexpected), isError: true, buildContext: context);
    });
  }

  void show(BuildContext containerContext) {
    showRoundedModalBottomSheet(
      radius: 20.0,
      color: Colors.white,
      dismissOnTap: false,
      context: containerContext,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(bottom: 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildGrabber(context),
              SizedBox(height: 20.0),
              _buildMarkInappropriateQuestion(containerContext),
              Divider(),
              _buildMarkDuplicateQuestion(context),
            ],
          ),
        );
      },
    );
  }
}
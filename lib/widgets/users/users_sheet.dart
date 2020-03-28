
import 'package:flutter/material.dart';
import 'package:schoolmi/models/data/profile.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/network/parsers/question_viewers.dart';
import 'package:schoolmi/network/parsers/reporters.dart';
import 'package:schoolmi/widgets/cells/user.dart';
import 'package:schoolmi/widgets/cells/viewer.dart';
import 'package:schoolmi/widgets/listviews/users.dart';
import 'package:schoolmi/widgets/users/reporters_sheet.dart';

class UsersSheet {


  static void showUsers({ @required BuildContext context, List<Profile> profiles }) {
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return ListView.builder(itemBuilder: (BuildContext context, int position) {
        return UserCell(profiles[position]);
      }, itemCount: profiles.length);
    });
  }

  static void showReporters( { @required BuildContext context, int questionId, int answerId, int commentId, Function onDeleteMarkingPressed }) {
    ReportersParser parser = ReportersParser(UserService().loginResult.activeChannel, questionId: questionId, answerId: answerId, commentId: commentId);
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return ReportersSheet(parser, onDeleteMarkingPressed: () {
        Navigator.pop(context);
        if (onDeleteMarkingPressed != null) {
          onDeleteMarkingPressed();
        }
      });
    });
  }

  static void showViewers( { @required BuildContext context, int questionId }) {
    QuestionViewersParser parser = QuestionViewersParser(UserService().loginResult.activeChannel, questionId: questionId);
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return UsersListView(parser, customCellBuilder: (viewer) {
        return QuestionViewerCell(viewer);
      });
    });
  }

}
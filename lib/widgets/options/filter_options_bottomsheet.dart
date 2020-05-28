import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/widgets/options/users_options_picker.dart';

class UsersSelection {

  static final int everyone = 1;
  static final int specificRoles = 2;
  static final int specificUsers = 3;

  int selectedUsersOption = everyone;

  bool isSelected (int id) {
    return selectedUsersOption == id;
  }

  static Map<int, String> createAnswerHintConfig() {
    return {
      everyone: Localization().getValue(Localization().answerOptionEveryoneHint),
      specificRoles: Localization().getValue(Localization().answerOptionSpecificRolesHint),
      specificUsers: Localization().getValue(Localization().answerOptionSpecificUsersHint)
    };
  }

  static Map<int, String> createQuestionHintConfig() {
    return {
      everyone: Localization().getValue(Localization().questionOptionEveryoneHint),
      specificRoles: Localization().getValue(Localization().questionOptionSpecificRolesHint),
      specificUsers: Localization().getValue(Localization().questionOptionSpecificUsersHint)
    };
  }

  UsersSelection();

  UsersSelection.fromDictionary(Map<String, dynamic> dictionary) {
    selectedUsersOption = dictionary[Keys().selectedUserOption];
  }

  Map<String, dynamic> toDictionary() {
    return {
      Keys().selectedUserOption: selectedUsersOption
    };
  }

}

abstract class FilterOptionsManager {

  List<Widget> buildOptions();

  UsersSelection usersSelection = UsersSelection();

  void showFilterOptions (BuildContext context, { Function(BuildContext, FilterOptionsManager) onApplyPressed }) {
    showBottomSheet(context: context, builder: (BuildContext context) {
      return Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20
              ),
              child: Row(
                children: <Widget>[
                  TitleLabel(
                    title: Localization().getValue(Localization().filter),
                  ),
                  Spacer(),
                  RaisedButton(
                    child: Row(
                      children: <Widget>[
                        Text(
                          Localization().getValue(Localization().apply),
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.check, color: Colors.white)
                      ],
                    ),
                    onPressed: () {
                      if (onApplyPressed != null) {
                        onApplyPressed(context, this);
                      }
                    },
                    elevation: 0,
                    focusElevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),

                  )
                ],
              ),
              decoration: BoxDecoration(
                  color: BrandColors.blueGrey,
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: BrandColors.blueGrey
                      )
                  )
              ),
            ),
            Expanded(
              child: SafeArea(
                child: Container(
                  child: ListView(
                    children: buildOptions(),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  void copy(FilterOptionsManager manager) {
    this.usersSelection = UsersSelection.fromDictionary(manager.usersSelection.toDictionary());
  }

}

class AnswersFilterOptionsManager extends FilterOptionsManager {

  bool showDeletedAnswers = false;

  @override
  List<Widget> buildOptions() {
    return [
      SwitchListTile(
        title: RegularLabel(
          title: Localization().getValue(Localization().showDeletedAnswers),
          fontWeight: FontWeight.bold,
          color: BrandColors.darkGrey,
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 20
        ),
        value: showDeletedAnswers,
        onChanged: (value) {
          showDeletedAnswers = value;
        },
      ),
      Divider(),
      UsersOptionsPicker(this, hintConfig: UsersSelection.createAnswerHintConfig())
    ];
  }

  @override
  void copy(FilterOptionsManager manager) {
    super.copy(manager);
    AnswersFilterOptionsManager answersManager = manager;
    showDeletedAnswers = answersManager.showDeletedAnswers;
  }

}


class QuestionsFilterOptionsManager extends FilterOptionsManager {

  bool showOnlyUnansweredQuestions = false;
  bool showOnlyFollowedQuestions = false;

  @override
  List<Widget> buildOptions() {
    return [
      SwitchListTile(
        title: RegularLabel(
          title: Localization().getValue(Localization().showOnlyUnansweredQuestions),
          fontWeight: FontWeight.bold,
          color: BrandColors.darkGrey,
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 20
        ),
        value: showOnlyUnansweredQuestions,
        onChanged: (value) {
          showOnlyUnansweredQuestions = value;
        },
      ),
      SwitchListTile(
        title: RegularLabel(
          title: Localization().getValue(Localization().showOnlyFollowedQuestions),
          fontWeight: FontWeight.bold,
          color: BrandColors.darkGrey,
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 20
        ),
        value: showOnlyFollowedQuestions,
        onChanged: (value) {
          showOnlyFollowedQuestions = value;
        },
      ),
      Divider(),
      UsersOptionsPicker(this, hintConfig: UsersSelection.createQuestionHintConfig())
    ];
  }

  @override
  void copy(FilterOptionsManager manager) {
    super.copy(manager);
    QuestionsFilterOptionsManager questionsManager = manager;
    showOnlyFollowedQuestions = questionsManager.showOnlyFollowedQuestions;
    showOnlyUnansweredQuestions = questionsManager.showOnlyUnansweredQuestions;
  }
}
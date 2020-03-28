import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/models/data/duplicate_question.dart';
import 'package:schoolmi/models/data/question.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/widgets/highlighted_widget.dart';
import 'package:schoolmi/widgets/labels/regular.dart';

class DuplicateQuestionCell extends StatelessWidget {

  final DuplicateQuestion question;
  final Function(DuplicateQuestion) showReporters;
  final Function(Question) showQuestion;
  final Function(DuplicateQuestion) deleteMarking;

  DuplicateQuestionCell (this.question, { this.showQuestion, this.showReporters, this.deleteMarking });

  String get reportersAsString {
    return Localization().buildUsersString(question.reporters, maxUsersLength: 4);
  }

  Widget _buildActionItem({ Color color, Color highlightedColor, VoidCallback onPressed, IconData iconData, String title }) {
    return HighlightedWidget(
      baseColor: color,
      highlightedColor: highlightedColor,
      onPressed: onPressed,
      renderWidget: (bool highlighted, Color color) {
        return Container(
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20)
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(iconData, color: Colors.white, size: 14),
                SizedBox(
                  width: 5,
                ),
                RegularLabel(
                  title: title,
                  color: Colors.white,
                  size: LabelSize.small,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: BrandColors.blueGrey,
                          width: 1
                      )
                  )
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          RegularLabel(
                            title: question.title,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          HighlightedWidget(
                            renderWidget: (bool isHighlighted, Color color) {
                              return Row(
                                children: <Widget>[
                                  Icon(Icons.person, color: color, size: 15),
                                  SizedBox(width: 5),
                                  Expanded(child: RegularLabel(
                                    title: reportersAsString,
                                    color: color,
                                    fontWeight: FontWeight.w300,
                                    font: LabelFont.montserrat,
                                    size: LabelSize.small,
                                  ))
                                ],
                              );
                            },
                            baseColor: Colors.black,
                            highlightedColor: Colors.blueGrey,
                            onPressed: () {
                              showReporters(question);
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Wrap(
                            children: <Widget>[
                              _buildActionItem(
                                  color: Colors.orange,
                                  highlightedColor: Colors.orange.withOpacity(0.5),
                                  title: Localization().getValue(Localization().viewQuestion),
                                  iconData: Icons.search,
                                  onPressed: () {
                                    Question newQuestion = Question(question.dictionary); //Used to prevent overriding object
                                    showQuestion(newQuestion);
                                  }
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Visibility(
                                  visible: UserService().loginResult.activeChannel.isUserAdmin,
                                  child: _buildActionItem(
                                      color: Colors.red,
                                      highlightedColor: Colors.red.withOpacity(0.5),
                                      title: Localization().getValue(Localization().deleteMarking),
                                      iconData: Icons.delete,
                                      onPressed: () {
                                        deleteMarking(question);
                                      }
                                  )
                              )

                            ],
                          )

                        ],
                      )
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: BrandColors.blue,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: RegularLabel(
                            title: question.reporters.length.toString() + "x",
                            size: LabelSize.small,
                            color: Colors.white,
                          )
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RegularLabel(
                        title: Localization().getValue(Localization().marked),
                        size: LabelSize.small,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        )
    );
  }

}
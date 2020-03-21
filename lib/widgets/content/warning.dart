import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/models/data/answer.dart';
import 'package:schoolmi/models/data/question.dart';
import 'package:schoolmi/network/auth/user_service.dart';

class Warning extends StatelessWidget {

  final bool visible;
  final Color color;
  final Color textColor;
  final String title;
  final IconData iconData;
  final Function onPressed;
  final EdgeInsets margin;
  final BoxDecoration boxDecoration;


  Warning ({ this.visible, this.color, this.title, this.textColor = Colors.white, this.iconData, this.onPressed, this.margin, this.boxDecoration });

  static bool get _isAdminOfCurrentChannel {
    return UserService().loginResult.activeChannel.isUserAdmin;
  }

  static Warning questionMarkedDeleted(Question question, { Function onPressed }) {
    return Warning(
      visible: question.isDeleted,
      title: Localization().getValue(Localization().questionDeleted),
      iconData: _isAdminOfCurrentChannel ? Icons.undo : null,
      color: Colors.red,
      onPressed: onPressed,
    );
  }

  static Warning questionMarkedFlagged(Question question, { Function onPressed }) {
    return Warning(
      visible: question.flagged,
      title: Localization().getValue(Localization().questionFlagged),
      color: Colors.orange,
      onPressed: onPressed,
    );
  }

  static Warning answerMarkedFlagged(Answer answer, { Function onPressed }) {
    return Warning(
      visible: answer.flagged,
      title: Localization().getValue(Localization().answerFlagged),
      color: Colors.orange,
      onPressed: onPressed,
    );
  }

  static Warning questionMarkedDuplicated(Question question, { Function onPressed }) {
    return Warning(
      visible: question.duplicated,
      title: Localization().getValue(Localization().questionDuplicate),
      boxDecoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: BrandColors.blueGrey
              )
          ),
          color: BrandColors.grey
      ),
      iconData: Icons.chevron_right,
      onPressed: onPressed,
      margin: EdgeInsets.all(0),
    );
  }

  static Warning answerMarkedDeleted(Answer answer, { Function onPressed }) {
    return Warning(
      visible: answer.isDeleted,
      title: Localization().getValue(Localization().answerDeleted),
      iconData: _isAdminOfCurrentChannel ? Icons.undo : null,
      color: Colors.red,
      onPressed: onPressed,
    );
  }



  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
          margin: margin ?? EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10
          ),
          child: Material(
              child: InkWell(
                child: Container(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Container(
                          child: Text(
                            title,
                            style: TextStyle(
                                fontSize: 13,
                                color: textColor
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10
                          ),
                        )),
                        Icon(iconData, color: Colors.white)
                      ],
                    ),
                  ),
                ),
                onTap: onPressed,
                borderRadius: boxDecoration != null ? boxDecoration.borderRadius : BorderRadius.circular(40),
              ),
              color: Colors.transparent
          ),
          decoration: boxDecoration ?? BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(40)
          ),
      ),
    );
  }


}
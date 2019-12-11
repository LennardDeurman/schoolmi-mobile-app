import 'package:flutter/material.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/widgets/labels/regular.dart';


class MessageContainer extends StatelessWidget {

  final String title;
  final String subtitle;
  final Widget topWidget;

  MessageContainer ({this.title, this.subtitle, this.topWidget});

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Visibility(child: Padding(
          child: topWidget ?? Container(),
          padding: EdgeInsets.only(bottom: 30),
        ), visible: topWidget != null),
        Visibility(child: Padding(child: TitleLabel(
          title: title ?? "",
          size: TitleSize.big,
          textAlign: TextAlign.center,
        ), padding: EdgeInsets.all(10))),
        Visibility(
          child: Padding(
            child: RegularLabel(
              title: subtitle ?? "",
              textAlign: TextAlign.center,
            ),
            padding: EdgeInsets.all(10)
          ),
          visible: subtitle != null,
        )
      ],
    ));
  }

}
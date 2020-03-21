import 'package:flutter/material.dart';
import 'package:schoolmi/models/options.dart';
import 'package:schoolmi/widgets/highlighted_widget.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/widgets/options/options_bar_state.dart';

class AnswersOptionsBar extends StatefulWidget {

  final String title;
  final OptionsBox orderOptionsBox;
  final Function(Option) onChange;

  AnswersOptionsBar ({ this.title, this.orderOptionsBox, this.onChange });

  @override
  State<StatefulWidget> createState() {
    return _AnswerOptionsState();
  }



}


class _AnswerOptionsState extends OptionsBarState<AnswersOptionsBar> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20
            ),
            child: TitleLabel(
                title: this.widget.title,
                size: TitleSize.small
            )
        ),
        Spacer(),
        HighlightedWidget(
          renderWidget: (bool isHighlighted, Color color) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    this.widget.orderOptionsBox.name,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                      this.widget.orderOptionsBox.value.name,
                      style: TextStyle(
                          fontSize: 10
                      )
                  )
                ],
              ),
              padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20
              ),
            );
          },
          onPressed: () {
            showOptionsPicker(this.widget.orderOptionsBox, (int selectedOption) {
              if (this.widget.onChange != null) {
                this.widget.onChange(this.widget.orderOptionsBox.value);
              }
            });
          },
        )

      ],
    );
  }

}
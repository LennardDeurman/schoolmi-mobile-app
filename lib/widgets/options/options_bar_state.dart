
import 'package:flutter/material.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/models/options.dart';
import 'package:schoolmi/widgets/highlighted_widget.dart';
import 'package:schoolmi/widgets/labels/regular.dart';

abstract class OptionsBarState<T extends StatefulWidget> extends State<T> {

  void showOptionsPicker(OptionsBox optionsBox, Function(int) onOptionPressed) {
    showRoundedModalBottomSheet(
      radius: 20.0,
      color: Colors.white,
      dismissOnTap: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(bottom: 40.0),
          child: ListView.builder(itemBuilder: (BuildContext context, int position) {

            return HighlightedWidget(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    optionsBox.selectedIndex = position;
                  });

                  onOptionPressed(position);

                }, baseColor: Colors.black,
                renderWidget: (bool highlighted, Color color) {
                  return Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: RegularLabel(
                              title: optionsBox.stringAtIndex(position),
                              color: color,
                              fontWeight: optionsBox.selectedIndex == position ? FontWeight.bold : FontWeight.normal,
                            )
                        ),
                        Icon(Icons.chevron_right, color: BrandColors.darkBlueGrey)
                      ],
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color: BrandColors.blueGrey
                            )
                        )
                    ),
                  );
                }
            );
          }, itemCount: optionsBox.optionsCount),
        );
      },
    );
  }

}
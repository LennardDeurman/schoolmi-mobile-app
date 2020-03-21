import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/highlighted_widget.dart';

class ContentActionsBar extends StatelessWidget {

  final Function onReplyPressed;
  final Function onEditPressed;

  ContentActionsBar ({ this.onEditPressed, this.onReplyPressed });


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: BrandColors.blueGrey
              )
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(

            child: HighlightedWidget(
              renderWidget: (bool highlighted, Color color) {
                return FlatButton.icon(
                    icon: Icon(Icons.add_comment, size: 20, color: color), //`Icon` to display
                    label: Text(Localization().getValue(Localization().reply), style: TextStyle(
                        color: color
                    )) //`Text` to displa
                );
              },
              onPressed: onReplyPressed,
            ),
          ),
          Expanded(
            child: HighlightedWidget(
              renderWidget: (bool highlighted, Color color) {
                return FlatButton.icon(
                    icon: Icon(Icons.edit, size: 20, color: color), //`Icon` to display
                    label: Text(Localization().getValue(Localization().edit), style: TextStyle(
                        color: color
                    )) //`Text` to displa
                );
              },
              onPressed: onEditPressed,
            ),
          )
        ],
      ),
    );
  }

}
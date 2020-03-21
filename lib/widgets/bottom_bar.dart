import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';

class BottomBar extends StatelessWidget {

  final Function onCancelPressed;
  final Function onConfirmPressed;

  BottomBar ({ this.onCancelPressed, this.onConfirmPressed });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: 1,
                    color: BrandColors.blueGrey
                )
            )
        ),
        child: Row(
          children: <Widget>[
            FlatButton(
              child: Text(Localization().getValue(Localization().cancel)),
              onPressed: onCancelPressed,
            ),
            Spacer(),
            RaisedButton(
              child: Text(
                Localization().getValue(Localization().confirm),
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              onPressed: onConfirmPressed,
            )
          ],
        ),
      );
  }

}
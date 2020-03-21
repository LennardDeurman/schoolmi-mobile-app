import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';

class BaseCell extends StatelessWidget {

  final Widget leading;
  final Widget trailing;
  final List<Widget> columnWidgets;
  final Border border;
  final Function onPressed;

  Border get defaultBorder {
    return Border(
        bottom: BorderSide(
            width: 1,
            color: BrandColors.blueGrey
        )
    );
  }

  BaseCell ({ this.leading, @required this.columnWidgets, this.border, this.onPressed,
    this.trailing
  });

  void _onPressed() {

  }


  @override
  Widget build(BuildContext context) {
    return Container(child: Material(
        color: Colors.white,
        child: InkWell(
      child: Container(
        child: Row(
          children: <Widget>[
            this.leading == null ? SizedBox(width: 10) : Container(child: this.leading, padding: EdgeInsets.all(10)),
            Expanded(child: Container(child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: this.columnWidgets,
            ), padding: EdgeInsets.only(
                left: 5,
                right: 10,
                top: 20,
                bottom: 20
            ))),
            this.trailing ?? Container()
          ],
        ),
        decoration: BoxDecoration(
            border: this.border ?? defaultBorder,
        ),
      ),
      onTap: () {
         if (this.onPressed != null) {
           return () {
             if (this.onPressed != null){
               this.onPressed();
             }
           };
         }

         return null;
      }(),
    )));
  }


}
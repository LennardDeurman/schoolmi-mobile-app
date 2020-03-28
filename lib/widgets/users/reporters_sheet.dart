import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/network/parsers/reporters.dart';
import 'package:schoolmi/widgets/listviews/users.dart';

class ReportersSheet extends StatelessWidget {

  final ReportersParser parser;
  final Function onDeleteMarkingPressed;

  ReportersSheet (this.parser, { this.onDeleteMarkingPressed });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 10
            ),
            child: Row(
              children: <Widget>[
                Spacer(),
                RaisedButton(
                  color: Colors.red,
                  child: Text(Localization().getValue(Localization().deleteMarking), style: TextStyle(color: Colors.white)),
                  onPressed: onDeleteMarkingPressed,
                  elevation: 0,
                  focusElevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),

              ],
            ),
          ),
          Expanded(
              child: UsersListView(parser)
          )
        ],
      ),
    );
  }
}
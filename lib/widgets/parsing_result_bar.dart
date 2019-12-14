import 'package:flutter/material.dart';
import 'package:schoolmi/models/parsing_result.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/extensions/dates.dart';
import 'package:schoolmi/localization/localization.dart';

class ParsingResultBar extends StatelessWidget {

  final ParsingResult parsingResult;
  final bool isLoading;

  ParsingResultBar (this.parsingResult, { bool this.isLoading });

  @override
  Widget build(BuildContext context) {
    return Container(child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Visibility(child: SizedBox(width: 15, height: 15, child: CircularProgressIndicator(
          strokeWidth: 2,
        )), visible: isLoading),
        Visibility(child: SizedBox(
          width: 10,
        ), visible: isLoading),
        Visibility(child: Text(
          Localization().buildWithParams(Localization().resultsRetrievedAt, [Dates.format(parsingResult.dateTime, format: Dates.dateTimeFormat)]),
          style: TextStyle(
              fontSize: 12
          ),
        ), visible: parsingResult != null)
      ],
    ), padding: EdgeInsets.symmetric(vertical: 8), color: BrandColors.blueGrey);
  }

}
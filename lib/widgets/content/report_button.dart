import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/highlighted_widget.dart';

class ReportButton extends StatelessWidget {


  final Function onPressed;
  final bool flaggedByMe;

  ReportButton ({this.onPressed, this.flaggedByMe});

  @override
  Widget build(BuildContext context) {
    return HighlightedWidget(
      onPressed: onPressed,
      baseColor: Colors.black54,
      highlightedColor: BrandColors.blue,
      selected: flaggedByMe,
      selectedColor: Colors.deepOrange,
      renderWidget: (bool highlighted, Color currentColor) {
        return Text(
          Localization().getValue(flaggedByMe ? Localization().reported : Localization().report),
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: currentColor
          ),
        );
      },
    );
  }

}
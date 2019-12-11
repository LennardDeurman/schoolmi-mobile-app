import 'package:flutter/material.dart';
import 'package:schoolmi/constants/fonts.dart';
import 'package:schoolmi/constants/brand_colors.dart';

class RegularLabel extends StatelessWidget {
  final String title;
  final Color color;
  final FontWeight fontWeight;
  final LabelSize size;
  final LabelFont font;
  final TextAlign textAlign;

  RegularLabel({
    @required this.title,
    this.color = BrandColors.black,
    this.fontWeight = FontWeight.w400,
    this.size = LabelSize.regular,
    this.font = LabelFont.lato,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      this.title,
      textAlign: this.textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: this.font == LabelFont.lato ? Fonts.lato : Fonts.montserrat,
        fontWeight: this.fontWeight,
        color: this.color,
      ),
    );
  }

  double get fontSize {
    switch (this.size) {
      case LabelSize.large:
        return 21.0;
      case LabelSize.big:
        return 19.0;
      case LabelSize.medium:
        return 17.0;
      case LabelSize.regular:
        return 15.0;
      case LabelSize.small:
        return 11.0;
      default:
        return 15.0;
    }
  }
}

enum LabelSize {
  large, //21
  big, //19
  medium, //17
  regular, //15
  small, //11
}

enum LabelFont {
  lato,
  montserrat,
}

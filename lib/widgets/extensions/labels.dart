import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/constants/fonts.dart';

//Enums start

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


enum TitleSize {
  large, //32
  big, //24
  medium, //19
  regular, //17
  small, //15
  extraSmall, //7
}

//End enums

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


class TitleLabel extends StatelessWidget {
  final TitleSize size;
  final String title;
  final TextAlign textAlign;
  final Color color;
  TitleLabel({
    this.size = TitleSize.regular,
    this.title,
    this.color = BrandColors.black,
    this.textAlign = TextAlign.left
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      this.title,
      style: TextStyle(
        fontSize: this.fontSize,
        fontWeight: FontWeight.w800,
        color: this.color,
      ),
      textAlign: textAlign,
    );
  }

  double get fontSize {
    switch (this.size) {
      case TitleSize.large:
        return 32.0;
      case TitleSize.big:
        return 24.0;
      case TitleSize.medium:
        return 19.0;
      case TitleSize.regular:
        return 17.0;
      case TitleSize.small:
        return 15.0;
      case TitleSize.extraSmall:
        return 7.0;
      default:
        return 15.0;
    }
  }
}

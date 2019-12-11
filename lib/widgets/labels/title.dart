import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';

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

enum TitleSize {
  large, //32
  big, //24
  medium, //19
  regular, //17
  small, //15
  extraSmall, //7
}

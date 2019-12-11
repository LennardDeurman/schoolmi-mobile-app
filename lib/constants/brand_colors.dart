import 'dart:math';
import 'package:flutter/material.dart';

class BrandColors {

  static const Color blue = Color(0xff55ACEE);
  static const Color red = Color(0xffFF6369);
  static const Color green = Color(0xff9BD075);
  static const Color orange = Color(0xffF9B25F);
  static const Color purple = Color(0xff84248B);
  static const Color yellow = Color(0xffD5BD1E);
  static const Color darkRed = Color(0xff91032F);
  static const Color cyan = Color(0xff067E87);
  static const Color darkBlue = Color(0xff060687);
  static const Color darkGreen = Color(0xff009270);
  static const Color lightGreen = Color(0xff1ec31e);
  static const Color lightGrey = Color(0xffC5C3C3);
  static const Color grey = Color(0xffA7A7A7);
  static const Color darkGrey = Color(0xff5C5C5C);
  static const Color blueGrey = Color(0xffECEFF2);
  static const Color darkBlueGrey = Color(0xffA3CBF2);
  static const Color black = Color(0xff3B3B3B);

  static const List avatarColors = [blue, red, green, orange, purple, yellow, darkRed, cyan, darkBlue, darkGreen, darkGrey];

  static Color avatarColor({int index}) {
    if (index != null) {
      return avatarColors[index];
    }
    int rndIndex = randomColorIndex();
    return avatarColors[rndIndex];
  }


  static int randomColorIndex() {
    Random random = new Random();
    return random.nextInt(avatarColors.length);
  }
}

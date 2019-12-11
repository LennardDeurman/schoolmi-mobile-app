import 'package:flutter/material.dart';

BoxDecoration shadowBox({
  double borderRadius = 10.0,
  bool onlyTopRadius = false,
  bool onlyBottomRadius = false,
  Color color = Colors.white,
  double xOffset = 0.0,
  double yOffset = 3.0,
  double blurRadius = 6.0,
  double alpha = 0.16,
}) {
  BorderRadius radius = BorderRadius.all(Radius.circular(borderRadius));
  if (onlyTopRadius) radius = BorderRadius.only(topLeft: Radius.circular(borderRadius), topRight: Radius.circular(borderRadius));
  if (onlyBottomRadius) radius = BorderRadius.only(bottomLeft: Radius.circular(borderRadius), bottomRight: Radius.circular(borderRadius));
  return BoxDecoration(
    color: color,
    borderRadius: radius,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(alpha),
        blurRadius: blurRadius,
        offset: Offset(xOffset, yOffset),
      )
    ],
  );
}

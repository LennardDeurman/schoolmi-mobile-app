import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolmi/constants/brand_colors.dart';

class SvgIcon extends StatelessWidget {
  final String assetUrl;
  final double size;
  final Color color;
  SvgIcon({
    @required this.assetUrl,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetUrl,
      width: size ?? 28.0,
      height: size ?? 28.0,
      fit: BoxFit.cover,
      color: this.color ?? BrandColors.black,
    );
  }
}

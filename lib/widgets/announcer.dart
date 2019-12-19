import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/widgets/labels/regular.dart';

class Announcer extends StatelessWidget {
  final String title;
  final double width;
  final Color color;
  Announcer({
    @required this.title,
    this.width = 130.0,
    this.color = BrandColors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: BrandColors.blueGrey,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Center(
        child: Container(
          width: width,
          height: 32.0,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              boxShadow: [
                BoxShadow(blurRadius: 6.0, offset: Offset(0.0, 3.0), color: Color(0xffBFBFBF))
              ]),
          child: Center(
            child: RegularLabel(
              title: title,
              color: Colors.white,
              size: LabelSize.regular,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
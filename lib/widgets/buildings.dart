import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:schoolmi/constants/asset_paths.dart';

class Buildings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SvgPicture.asset(
          AssetPaths.buildings,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}

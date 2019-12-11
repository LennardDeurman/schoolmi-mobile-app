import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:schoolmi/constants/asset_paths.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/localization/localization.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SvgPicture.asset(
          AssetPaths.logo,
          width: 40.0,
          fit: BoxFit.scaleDown,
        ),
        SizedBox(width: 15.0),
        TitleLabel(
          size: TitleSize.large,
          title: Localization().getValue(Localization().appName),
        ),
      ],
    );
  }
}

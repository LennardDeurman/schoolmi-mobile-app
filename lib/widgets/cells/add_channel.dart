import 'package:flutter/material.dart';
import 'package:schoolmi/widgets/cells/base_cell.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/widgets/svg_icon.dart';
import 'package:schoolmi/constants/asset_paths.dart';
import 'package:schoolmi/widgets/labels/regular.dart';


class AddChannelCell extends StatelessWidget {

  final String title;
  final String subtitle;
  final Function onPressed;

  AddChannelCell({ this.title, this.subtitle, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BaseCell(
      leading: Container(
        decoration: BoxDecoration(
          color: BrandColors.blue,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(child: SvgIcon(
          assetUrl: AssetPaths.add,
          color: Colors.white,
        ), padding: EdgeInsets.all(12)),
        width: 40,
        height: 40,
      ),
      columnWidgets: <Widget>[
        RegularLabel(
          title: title,
          fontWeight: FontWeight.w800,
        ),
        SizedBox(height: 2.0),
        RegularLabel(
          title: subtitle,
          size: LabelSize.small,
          color: BrandColors.grey,
        )
      ],
      border: Border(
          bottom: BorderSide(
              width: 1,
              color: BrandColors.blueGrey
          ),
          left: BorderSide(
              width: 6,
              color: Colors.transparent
          )
      ),
      onPressed: onPressed,
    );
  }

}
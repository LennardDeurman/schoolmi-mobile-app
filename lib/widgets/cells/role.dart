import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/network/models/role.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';


class RoleCell extends StatelessWidget {

  final Role role;
  final Function(Role) onRolePressed;
  final bool isSelected;

  RoleCell (this.role, { this.onRolePressed, this.isSelected = false });

  @override
  Widget build(BuildContext context) {
    return Container(child: Material(child: InkWell(child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10
        ),
        child: Row(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RegularLabel(
                  title: role.name,
                  fontWeight: FontWeight.bold,
                ),
                Visibility(
                    visible: role.id == null,
                    child: RegularLabel(
                      title: Localization().getValue(Localization().newRoleHint),
                      customSize: 12,
                    )
                )
              ],
            ),
            Spacer(),
            Visibility(
              child: Icon(Icons.check_circle, color: BrandColors.green),
              visible: isSelected,
            ),
            Visibility(
              child: Icon(Icons.chevron_right, color: BrandColors.grey),
              visible: !isSelected,
            ),

          ],
        )
    ), onTap: () {
      if (this.onRolePressed != null) {
        this.onRolePressed(role);
      }
    }), color: Colors.transparent), decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(
                width: 1,
                color: BrandColors.blueGrey
            )
        )
    ));
  }


}
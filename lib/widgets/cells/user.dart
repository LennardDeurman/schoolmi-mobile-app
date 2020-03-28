import 'package:flutter/material.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/models/data/profile.dart';
import 'package:schoolmi/widgets/cells/base_cell.dart';
import 'package:schoolmi/widgets/circle_image.dart';
import 'package:schoolmi/widgets/labels/regular.dart';

class UserCell extends StatelessWidget {

  final Profile profile;

  UserCell (this.profile);


  @override
  Widget build(BuildContext context) {
    return BaseCell(
      leading: CircleImage.withAvatarObject(profile),
      columnWidgets: <Widget>[
        RegularLabel(
          title: profile.fullName,
          size: LabelSize.medium,
        ),
        RegularLabel(
          title: profile.username,
          size: LabelSize.small,
          fontWeight: FontWeight.w300,
        ),
        Visibility(child: Container(
          child: RegularLabel(
            title: profile.roleName ?? "",
            size: LabelSize.small,
            fontWeight: FontWeight.bold,
            customSize: 12,
          ),
          margin: EdgeInsets.only(
              top: 4
          ),
        ), visible: profile.roleName != null)
      ],
      trailing: Visibility(visible: profile.isAdmin, child:  Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Icon(Icons.supervisor_account),
            RegularLabel(
              title: Localization().getValue(Localization().admin),
              size: LabelSize.small,
            )
          ],
        ),
      )),
      onPressed: () {
      },
    );
  }

}


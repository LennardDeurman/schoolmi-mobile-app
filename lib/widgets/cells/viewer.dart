import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/extensions/dates.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/models/data/question_viewer.dart';
import 'package:schoolmi/widgets/cells/base_cell.dart';
import 'package:schoolmi/widgets/circle_image.dart';
import 'package:schoolmi/widgets/labels/regular.dart';

class QuestionViewerCell extends StatelessWidget {

  final QuestionViewer viewer;

  QuestionViewerCell (this.viewer);

  @override
  Widget build(BuildContext context) {
    return BaseCell(
      leading: CircleImage.withAvatarObject(viewer),
      columnWidgets: <Widget>[

        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            RegularLabel(
              title: viewer.fullName,
              size: LabelSize.medium,
            ),
            SizedBox(
              width: 5,
            ),
            Visibility(
              child: Icon(Icons.supervisor_account, size: 16, color: Colors.grey),
              visible: viewer.isAdmin,
            )
          ],
        ),
        RegularLabel(
          title: viewer.username,
          size: LabelSize.small,

          fontWeight: FontWeight.w300,
        ),
        SizedBox(
          height: 5,
        ),
        RegularLabel(
          title: Localization().getValue(Localization().viewedOn) + Dates.format(viewer.viewTime, format: Dates.friendlyFormat),
          size: LabelSize.small,
          fontWeight: FontWeight.bold,
        ),
      ],
      trailing: Visibility(child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: 10
        ),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: BrandColors.blueGrey
        ),
        child: RegularLabel(
          title: viewer.roleName ?? "",
          size: LabelSize.small,
          fontWeight: FontWeight.bold,
        ),
      ), visible: viewer.roleName != null),
      onPressed: () {

      },
    );
  }

}
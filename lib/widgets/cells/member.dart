import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/models/data/member.dart';
import 'package:schoolmi/widgets/cells/base_cell.dart';
import 'package:schoolmi/widgets/circle_image.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/models/data/channel.dart';

class MemberCell extends StatelessWidget {

  final Member member;
  final Channel channel;
  final Function(Member) onPressed;

  MemberCell ({@required this.member, @required this.channel, this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (this.member.profile != null) {
      return _buildCell();
    }
    return _buildAnonymousCell();
  }

  Widget _buildCell() {
    return BaseCell(
      leading: CircleImage(
        imageUrl: member.profile.profileImageUrl,
        firstLetter: member.profile.firstLetter,
        avatarColor: BrandColors.avatarColor(index: member.profile.colorIndex),
      ),
      columnWidgets: <Widget>[
        RegularLabel(
          title: member.profile.fullName,
          size: LabelSize.medium,
        ),
        Visibility(child: RegularLabel(
          title: member.email,
          size: LabelSize.small,
          fontWeight: FontWeight.w300,
        ), visible: channel.isUserAdmin)
      ],
      trailing: Visibility(visible: member.isAdmin, child:  Container(
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
        onPressed(member);
      },
    );
  }

  Widget _buildAnonymousCell() {
    return BaseCell(
      leading: CircleImage(
        firstLetter: member.firstLetter,
      ),
      columnWidgets: <Widget>[
        RegularLabel(
          title: member.email,
          size: LabelSize.medium,
        ),
        RegularLabel(
          title: Localization().getValue(Localization().noAccountMatched),
          size: LabelSize.small,
        )
      ],
      trailing: Visibility(visible: member.isAdmin, child:  Container(
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
      border: Border(
          bottom: BorderSide(
              width: 1,
              color: BrandColors.blueGrey
          )
      ),
      onPressed: () {
        onPressed(member);
      },
    );
  }



}
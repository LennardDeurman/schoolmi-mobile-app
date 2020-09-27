import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/network/models/member.dart';
import 'package:schoolmi/widgets/cells/base.dart';
import 'package:schoolmi/widgets/circle_image.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/network/models/channel.dart';

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
    return Cell(
      leading: CircleImage.withAvatarObject(member),
      columnWidgets: <Widget>[
        RegularLabel(
          title: member.profile.fullName,
          size: LabelSize.medium,
        ),
        Visibility(child: RegularLabel(
          title: member.email,
          size: LabelSize.small,
          fontWeight: FontWeight.w300,
        ), visible: channel.isCurrentUserAdmin),
        Visibility(
          visible: member.hasRole,
          child: RegularLabel(
            title: member.hasRole ? member.role.name : "",
            fontWeight: FontWeight.bold,
            customSize: 12,
          ),
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
      onPressed: () {
        onPressed(member);
      },
    );
  }

  Widget _buildAnonymousCell() {
    return Visibility(visible: channel.isCurrentUserAdmin, child: Cell(
      leading: CircleImage.withAvatarObject(member),
      columnWidgets: <Widget>[
        RegularLabel(
          title: member.email ?? Localization().getValue(Localization().anonymous),
          size: LabelSize.medium,
        ),
        RegularLabel(
          title: Localization().getValue(Localization().noAccountMatched),
          size: LabelSize.small,
        ),
        Visibility(
          visible: member.hasRole,
          child: RegularLabel(
            title: member.hasRole ? member.role.name : "",
            fontWeight: FontWeight.bold,
            customSize: 12,
          ),
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
    ));
  }



}
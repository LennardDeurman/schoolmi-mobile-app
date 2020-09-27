import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolmi/network/models/channel.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/widgets/circle_image.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/widgets/cells/base.dart';
import 'package:schoolmi/constants/asset_paths.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';

class ChannelSummary extends StatelessWidget {

  final Function onEditChannelPressed;
  final Function onInvitePressed;
  final Function onNotificationSettingsPressed;
  final Function onMembersPressed;
  final Function onLeaveChannelPressed;
  final Function onTagsPressed;

  ChannelSummary ({ @required this.onEditChannelPressed, @required this.onInvitePressed, @required this.onNotificationSettingsPressed,
    @required this.onMembersPressed, @required this.onLeaveChannelPressed, @required this.onTagsPressed
  });

  Channel get activeChannel {
    return UserService().userResult.activeChannel;
  }

  Widget _buildChannelCell() {

    return Container(child: Material(child: InkWell(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15),
              child: Row(children: <Widget>[Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(child: CircleImage(
                    firstLetter: activeChannel.firstLetter,
                    imageUrl: activeChannel.imageUrl,
                    avatarColor: BrandColors.avatarColor(index: activeChannel.colorIndex),
                  ), margin: EdgeInsets.only(bottom: 20)),
                  Container(child: RegularLabel(
                    title: activeChannel.name,
                    fontWeight: FontWeight.bold,
                  ), margin: EdgeInsets.only(bottom: 2)),
                  Visibility(child: RegularLabel(
                    title: activeChannel.description ?? "",
                  ), visible: activeChannel.description != null)
                ],
              ))]),
            )
          ],
        )
    )));
  }

  Widget _buildCell({
    @required String title, String subtitle, bool hasChevron = false, Widget leading,
    Function onPressed, bool showBottomBorder = false, bool showTopBorder = true, bool requiresAdmin = false
  }) {

    return Visibility(visible: requiresAdmin ? activeChannel.isCurrentUserAdmin : true, child: Container(child: Cell(
      leading: leading,
      columnWidgets: <Widget>[
        RegularLabel(
          title: title,
          fontWeight: FontWeight.bold,
        ),
        Visibility(child: RegularLabel(
          size: LabelSize.small,
          title: subtitle ?? "",
        ), visible: subtitle != null),
        Visibility(child: Container(
          child: RegularLabel(
            title: Localization().getValue(Localization().requiresAdmin),
            size: LabelSize.small,
            fontWeight: FontWeight.bold,
          ),
          padding: EdgeInsets.only(top: 5),
        ), visible: requiresAdmin)
      ],
      trailing: hasChevron ? Container(
        padding: EdgeInsets.all(10),
        child: Icon(
          Icons.chevron_right,
          color: BrandColors.grey,
        ),
      ) : null,
      onPressed: onPressed,
      border: Border(
          bottom: BorderSide(
              width: 1,
              color: showBottomBorder ? BrandColors.blueGrey : Colors.transparent
          ),
          top: BorderSide(
              width: 1,
              color: showTopBorder ? BrandColors.blueGrey : Colors.transparent
          )
      ),
    )));
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(child: ListView(
        padding: EdgeInsets.only(top: 20),
        children: <Widget>[
          _buildChannelCell(),
          _buildCell(
              title: Localization().getValue(Localization().notificationSettings),
              subtitle: Localization().getValue(Localization().notificationSettingsExtra),
              leading: SvgPicture.asset(AssetPaths.bell, width: 20),
              hasChevron: true,
              onPressed: onNotificationSettingsPressed
          ),
          _buildCell(
              title: Localization().getValue(Localization().members, usePluralForm: true),
              subtitle: Localization().buildNumberAndText(Localization().members, count: activeChannel.membersCount),
              leading: SvgPicture.asset(AssetPaths.classRoom, width: 20),
              hasChevron: true,
              onPressed: onMembersPressed
          ),
          _buildCell(
              title: Localization().getValue(Localization().sendInviteLink),
              subtitle: Localization().getValue(Localization().sendInviteLinkExtra),
              leading: SvgPicture.asset(AssetPaths.paperPlane, width: 20),
              requiresAdmin: !activeChannel.isCurrentUserAdmin,
              hasChevron: true,
              onPressed: onInvitePressed
          ),
          _buildCell(
              title: Localization().getValue(Localization().changeGroupInformation),
              subtitle: Localization().getValue(Localization().changeGroupInformationExtra),
              requiresAdmin: !activeChannel.isCurrentUserAdmin,
              leading: SvgPicture.asset(AssetPaths.document, width: 20),
              hasChevron: true,
              onPressed: onEditChannelPressed
          ),
          _buildCell(
              title: Localization().getValue(Localization().tags),
              subtitle: Localization().getValue(Localization().tagsInformationExtra),
              requiresAdmin: !activeChannel.isCurrentUserAdmin,
              leading: SvgPicture.asset(AssetPaths.tag, width: 20),
              hasChevron: true,
              onPressed: onTagsPressed
          ),
          _buildCell(
              title: Localization().getValue(Localization().leaveChannel),
              subtitle: Localization().getValue(Localization().leaveChannelExtra),
              requiresAdmin: false,
              hasChevron: true,
              leading: SvgPicture.asset(AssetPaths.leave, width: 20),
              onPressed: onLeaveChannelPressed
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: RegularLabel(
              title: Localization().getValue(activeChannel.isCurrentUserAdmin ? Localization().youAreAdmin : Localization().youAreNotAdmin),
              size: LabelSize.small,
            ),
          ),
        ],
      )),
      color: BrandColors.blueGrey,
    );
  }
}
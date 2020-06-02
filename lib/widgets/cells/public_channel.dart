import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/network/parsing_result.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/widgets/cells/base_cell.dart';
import 'package:schoolmi/widgets/circle_image.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/localization/localization.dart';

class PublicChannelCell extends StatelessWidget {

  final Channel channel;
  final Function(Channel) onPressedJoin;

  PublicChannelCell ({this.channel, this.onPressedJoin});

  Widget _buildTrailing() {
    ParsingResult result = UserService().loginResult.myChannelsResult;
    if (result.objects.contains(channel)) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: FlatButton(
        color: BrandColors.blue,
        child: TitleLabel(
          title: Localization().getValue(Localization().becomeMember),
          size: TitleSize.small,
          color: Colors.white,
        ),
        onPressed: () {
          if (this.onPressedJoin != null)
            this.onPressedJoin(channel);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseCell(
      leading: CircleImage(
        imageUrl: channel.imageUrl,
        firstLetter: channel.firstLetter,
        avatarColor: BrandColors.avatarColor(index: channel.colorIndex),
      ),
      columnWidgets: <Widget>[
        TitleLabel(
          title: channel.name,
        ),
        RegularLabel(
          title: channel.description,
          fontWeight: FontWeight.normal,
        ),
        SizedBox(
          height: 6,
        ),
        RegularLabel(
          title: Localization().buildNumberAndText(Localization().members, count: channel.membersCount),
          fontWeight: FontWeight.w200,
        )
      ],
      border: Border(
          bottom: BorderSide(
              width: 1,
              color: BrandColors.blueGrey
          )
      ),
      trailing: _buildTrailing(),
    );
  }

}
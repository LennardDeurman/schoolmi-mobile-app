import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/cells/base.dart';
import 'package:schoolmi/widgets/circle_image.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/network/models/channel.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/constants/asset_paths.dart';

class ChannelCell extends StatelessWidget {

  final Channel channel;
  final bool isActive;
  final Function onPressed;

  ChannelCell ({@required this.channel, @required this.isActive, @required this.onPressed});

  @override
  Widget build(BuildContext context) {

    return Cell(
      leading: CircleImage(
        imageUrl: channel.imageUrl,
        firstLetter: channel.firstLetter,
        avatarColor: BrandColors.avatarColor(index: channel.colorIndex),
      ),
      columnWidgets: <Widget>[
        RegularLabel(
          title:  channel.name,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        )
      ],
      trailing: Container(
        width: 60,
        child: Center(
            child: Visibility(visible: false, child: Container(
              padding: EdgeInsets.all(5),
              child: Text(
                channel.updatesCount.toString(),
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8)
              ),
            ),
            )),
      ),
      border:  Border(
          left: BorderSide(
              width: 6,
              color: isActive ?  BrandColors.blue : Colors.transparent
          )
      ),
      onPressed: this.onPressed,
    );
  }

}


class AddChannelCell extends StatelessWidget {

  final String title;
  final String subtitle;
  final Function onPressed;

  AddChannelCell({ this.title, this.subtitle, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Cell(
      leading: Container(
        decoration: BoxDecoration(
          color: BrandColors.blue,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(child: SvgPicture.asset(
          AssetPaths.add,
          width: 28.0,
          height: 28.0,
          fit: BoxFit.cover,
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

class PublicChannelCell extends StatelessWidget {

  final Channel channel;
  final Function(Channel) onPressedJoin;

  PublicChannelCell ({this.channel, this.onPressedJoin});

  Widget _buildTrailing() {

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
    return Cell(
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
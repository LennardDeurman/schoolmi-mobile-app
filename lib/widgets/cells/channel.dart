import 'package:flutter/material.dart';
import 'package:schoolmi/widgets/cells/base_cell.dart';
import 'package:schoolmi/widgets/circle_image.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/constants/brand_colors.dart';


class ChannelCell extends StatelessWidget {


  final Channel channel;
  final bool isActive;
  final Function onPressed;

  ChannelCell ({@required this.channel, @required this.isActive, @required this.onPressed});


  @override
  Widget build(BuildContext context) {

    return BaseCell(
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
                "10",
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
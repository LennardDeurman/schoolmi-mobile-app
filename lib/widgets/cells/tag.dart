import 'package:flutter/material.dart';
import 'package:schoolmi/network/models/tag.dart';
import 'package:schoolmi/constants/brand_colors.dart';

class TagChip extends StatelessWidget {

  final String title;
  final Color color;
  final Function onDeleted;

  TagChip ({ this.title, this.color, this.onDeleted });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(title),
      onDeleted: onDeleted,
      backgroundColor: color,
      deleteIcon: onDeleted != null ? Icon(Icons.cancel) : null,
      deleteIconColor: Colors.white,
      labelStyle: TextStyle(
        color: Colors.white,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

}

class TagCell extends StatelessWidget {

  final Tag tag;
  final Widget leading;
  final Function(Tag tag) onTagPressed;

  TagCell (this.tag, { this.leading, this.onTagPressed });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
        child: Row(children: [
          TagChip(title: tag.name, color: BrandColors.grey),
          Spacer(),
          this.leading ?? Container(),
        ]), decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: BrandColors.blueGrey,
                width: 1
            )
        )
    ));
  }

}

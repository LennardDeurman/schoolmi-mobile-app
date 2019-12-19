import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/models/data/tag.dart';

class TagCell extends StatelessWidget {
  final String title;
  final Color color;
  TagCell({@required this.title, @required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0, right: 5.0),
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: this.color,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: RegularLabel(
        title: this.title,
        size: LabelSize.small,
        color: Colors.white,
      ),
    );
  }
}

class TagListItemCell extends StatelessWidget {

  final Tag tag;
  final Function(Tag tag) onTagPressed;

  TagListItemCell (this.tag, { this.onTagPressed });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTagPressed != null)
          onTagPressed(this.tag);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            SizedBox(width: 20.0),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Align(
                    child: TagCellWithIcon(color: BrandColors.grey, title: tag.name),
                    alignment: Alignment.centerLeft,
                  )
                ],
              ),
            ),
          ]),
          Divider()
        ],
      ),
    );
  }

}

class TagCellWithIcon extends StatelessWidget {
  final String title;
  final Color color;
  final Function onDeleted;
  TagCellWithIcon({
    @required this.title,
    this.color = BrandColors.blue,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0, right: 5.0),
      child: Chip(
        label: Text(title),
        onDeleted: onDeleted,
        backgroundColor: color,
        deleteIcon: Icon(Icons.cancel),
        deleteIconColor: Colors.white,
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

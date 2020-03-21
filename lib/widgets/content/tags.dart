import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/models/data/tag.dart';
import 'package:schoolmi/widgets/cells/tag.dart';

class TagsContainer extends StatelessWidget {

  final List<Tag> tags;

  TagsContainer ({this.tags});

  @override
  Widget build(BuildContext context) {
    List<Widget> tagWidgets = [];
    if (tags != null) {
      tags.forEach((Tag tag) {
        tagWidgets.add(TagCell(
          title: tag.name,
          color: BrandColors.avatarColor(index: tag.colorIndex),
        ));
      });
    }
    return Wrap(children: tagWidgets);
  }

}
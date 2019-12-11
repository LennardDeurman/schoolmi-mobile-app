import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/models/data/extensions/object_with_avatar.dart';

class CircleImage extends StatefulWidget {

  final String imageUrl;
  final String firstLetter;
  final Color avatarColor;

  CircleImage ({this.imageUrl, this.firstLetter, this.avatarColor});

  static CircleImage withAvatarObject(ObjectWithAvatar avatar) {
    return CircleImage(
      imageUrl: avatar.avatarImageUrl,
      firstLetter: avatar.firstLetter,
      avatarColor: BrandColors.avatarColor(index: avatar.avatarColorIndex)
    );
  }


  @override
  State<StatefulWidget> createState() {
    return _CircleImageState();
  }

}

class _CircleImageState extends State<CircleImage> {

  bool _imageFailedToLoad = false;

  String get firstLetter {
    if (widget.imageUrl != null) {
      return "";
    }
    return widget.firstLetter;
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: widget.avatarColor ?? BrandColors.avatarColor(),
      backgroundImage:widget.imageUrl != null ? CachedNetworkImageProvider(
          widget.imageUrl,
          errorListener: () {
            setState(() {
              _imageFailedToLoad = true;
            });
          }
      ) : null,
      child: Container(
        child: Center(
          child:  Visibility(child: RegularLabel(
            title: firstLetter,
            fontWeight: FontWeight.normal,
            font: LabelFont.montserrat,
            color: Colors.white,
          ), visible: _imageFailedToLoad || widget.imageUrl == null),
        ),
      ),
    );
  }
}
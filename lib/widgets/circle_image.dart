import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/network/models/extensions/object_with_avatar.dart';
import 'package:schoolmi/network/models/extensions/object_with_color.dart';

class CircleImage extends StatefulWidget {

  final String imageUrl;
  final String firstLetter;
  final Color avatarColor;

  CircleImage ({this.imageUrl, this.firstLetter, this.avatarColor});

  static CircleImage withAvatarObject(dynamic avatar) {
    if (avatar is ObjectWithAvatar && avatar is ObjectWithColor)
      throw UnimplementedError("Avatar object must be both an ObjectWithAvatar and an ObjectWithColor");
    return CircleImage(
      imageUrl: avatar.imageUrl,
      firstLetter: avatar.firstLetter,
      avatarColor: BrandColors.avatarColor(index: avatar.colorIndex)
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
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:schoolmi/constants/asset_paths.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/models/data/profile.dart';
import 'package:schoolmi/widgets/circle_image.dart';
import 'package:schoolmi/widgets/labels/regular.dart';

class MiniProfileWidget extends StatelessWidget {

  final Profile profile;

  MiniProfileWidget (this.profile);

  Widget _buildDummyContainer({ String title, String subtitle }) {
    return Row(
      children: <Widget>[
        SizedBox(
          height: 25,
          width: 25,
          child: CircleAvatar(
            child: Icon(Icons.account_circle, color: BrandColors.grey),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RegularLabel(
              title: title,
              size: LabelSize.small,
              fontWeight: FontWeight.bold,
            ),
            RegularLabel(
              title: subtitle,
              size: LabelSize.small,
              fontWeight: FontWeight.normal,
            )
          ],
        )
      ],
    );
  }

  Widget _buildContent() {

    if (profile == null) {
      return _buildDummyContainer(
        title: Localization().getValue(Localization().userDeleted),
        subtitle: Localization().getValue(Localization().userDeletedHint),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 25,
          width: 25,
          child: CircleImage(
            imageUrl: profile.profileImageUrl,
            firstLetter: profile.firstLetter,
            avatarColor: BrandColors.avatarColor(index: profile.colorIndex),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RegularLabel(
              title: profile.fullName,
              size: LabelSize.small,
              fontWeight: FontWeight.bold,
            ),
            Container(
              padding: EdgeInsets.only(top: 5.0),
              child: Row(
                children: <Widget>[
                  SvgPicture.asset(
                    AssetPaths.graduationCap,
                    fit: BoxFit.scaleDown,
                    height: 12.0,
                  ),
                  SizedBox(width: 6),
                  RegularLabel(
                    title: profile.score.toString(),
                    size: LabelSize.small,
                    fontWeight: FontWeight.w600,
                    color: BrandColors.darkGrey,
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(child: _buildContent(), decoration: BoxDecoration(
        color: BrandColors.blueGrey,
        border: Border.all(color: BrandColors.darkBlueGrey, width: 0.5),
        borderRadius: BorderRadius.circular(15)
    ), padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 15
    ));
  }

}
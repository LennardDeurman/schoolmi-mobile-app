import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/managers/view_question.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/widgets/content/mini_profile.dart';
import 'package:schoolmi/models/data/profile.dart';
import 'package:schoolmi/widgets/highlighted_widget.dart';
import 'package:schoolmi/localization/localization.dart';

abstract class DetailsBlock extends StatelessWidget {

  final ViewQuestionManager manager;

  DetailsBlock (this.manager);

  bool get canEditContent;

  static BoxDecoration get defaultBoxDecoration {
    return BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(
          width: 1,
          color: BrandColors.blueGrey
        )
      )
    );
  }

  //Shows the profile and the commentscount
  static Widget buildLowerContainer({ Profile profile, int commentsCount, Function onCommentsPressed }) {
    return Row(
      children: <Widget>[
        MiniProfileWidget(profile),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                  child: HighlightedText(
                    title: Localization().buildNumberAndText(Localization().reactions, count: commentsCount),
                    onPressed: onCommentsPressed,
                  )
              )
            ],
          ),
        )
      ],
    );
  }




}
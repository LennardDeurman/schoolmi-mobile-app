import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolmi/constants/asset_paths.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';


class MessageContainer extends StatelessWidget {

  final String title;
  final String subtitle;
  final Widget topWidget;
  final double customSubtitleSize;

  MessageContainer ({this.title, this.subtitle, this.topWidget, this.customSubtitleSize });

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Visibility(child: Padding(
          child: topWidget ?? Container(),
          padding: EdgeInsets.only(bottom: 30),
        ), visible: topWidget != null),
        Visibility(child: Padding(child: TitleLabel(
          title: title ?? "",
          size: TitleSize.big,
          textAlign: TextAlign.center,
        ), padding: EdgeInsets.all(10))),
        Visibility(
          child: Padding(
              child: RegularLabel(
                title: subtitle ?? "",
                textAlign: TextAlign.center,
                customSize: customSubtitleSize,
              ),
              padding: EdgeInsets.all(10)
          ),
          visible: subtitle != null,
        )
      ],
    ));
  }

}

class ListBackgrounds {

  static Widget buildNoResultsBackground() {
    return MessageContainer(
        topWidget: SvgPicture.asset(AssetPaths.search, width: 80),
        title: Localization().getValue(Localization().noResults),
        subtitle: Localization().getValue(Localization().noMatchingResults)
    );
  }

  static Widget buildLoadingBackground() {
    return MessageContainer(
      topWidget: CircularProgressIndicator(),
      title: Localization().getValue(Localization().busyLoading),
    );
  }

  static Widget buildErrorBackground(Exception exception) {
    return MessageContainer(
        topWidget: SvgPicture.asset(AssetPaths.warning, width: 80),
        title: Localization().getValue(Localization().errorUnexpected),
        subtitle: Localization().getValue(Localization().errorUnexpectedShort)
    );
  }

}
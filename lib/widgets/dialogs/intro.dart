import 'package:flutter/material.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/extensions/buttons.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';

class IntroDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TitleLabel(
              title: Localization().getValue(Localization().introWelcomeTitle),
              size: TitleSize.big,
            ),
            Container(
              child: RegularLabel(title: Localization().getValue(Localization().introSubtitle1)),
              margin: EdgeInsets.symmetric(
                  vertical: 10
              ),
            ),
            Container(
              child: RegularLabel(title: Localization().getValue(Localization().introSubtitle2)),
              margin: EdgeInsets.symmetric(
                  vertical: 10
              ),
            ),
            Container(
              child: RegularLabel(title: Localization().getValue(Localization().introSubtitle3)),
              margin: EdgeInsets.symmetric(
                  vertical: 10
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: DefaultButton(
                    child: RegularLabel(
                      color: Colors.white,
                      title: Localization().getValue(Localization().nextContinue),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}
import 'package:flutter/material.dart';
import 'package:schoolmi/widgets/listviews/advanced_listview.dart';
import 'package:schoolmi/widgets/cells/base_cell.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/localization/localization.dart';

class AddMembersListView extends StatelessWidget {

  final List<String> emails;
  final Function(String email) onRemovePressed;
  final Widget Function() formBuilder;
  final Channel channel;


  AddMembersListView ({ @required this.channel, @required this.emails, @required this.onRemovePressed, @required this.formBuilder });

  Widget _buildEmailWidget(String email) {
    return Container(child: BaseCell(
        columnWidgets: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 5
            ),
            child: RegularLabel(
              title: email,
            ),
          )
        ],
        trailing: IconButton(
          icon: Icon(Icons.delete, color: BrandColors.grey),
          onPressed: () {
            onRemovePressed(email);
          },
        )
    ));
  }


  @override
  Widget build(BuildContext context) {
    return AdvancedListView.builder(
      headerBuilder: (int section) {
        return Container(
          padding: EdgeInsets.all(20),
          child: RegularLabel(
            title: section == 0 ? channel.name : Localization().getValue(Localization().addedEmails),
            fontWeight: FontWeight.bold,
          ),
        );
      },
      itemBuilder: (BuildContext context, int rowIndex, int section) {

        if (section == 0) {
          return formBuilder();
        } else if (section == 1) {
          String email = emails[rowIndex];
          return _buildEmailWidget(email);
        }
        return null;
      },
      numberOfRows: (int section) {
        if (section == 0) {
          return 1;
        } else if (section == 1) {
          return emails.length;
        }
        return 0;
      },
      sectionCount: emails.length > 0 ? 2 : 1,
    );
  }

}
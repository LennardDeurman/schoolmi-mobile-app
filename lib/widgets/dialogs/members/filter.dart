import 'package:flutter/material.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/network/params/members.dart';
import 'package:schoolmi/widgets/cells/base.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';

class MembersFilterDialog {

  Function(MembersFilterMode) onOptionSelected;
  MembersFilterMode selectedOption;

  MembersFilterDialog ({this.onOptionSelected,  this.selectedOption });



  Widget _buildListItem({ IconData icon, String text, MembersFilterMode membersFilterMode }) {
    return Cell(
      leading: Icon(icon),
      columnWidgets: <Widget>[
        RegularLabel(
          title: text,
        )
      ],
      onPressed: () {
        onOptionSelected(membersFilterMode);
      },
      trailing: Visibility(
          visible: selectedOption == membersFilterMode,
          child: Container(
            margin: EdgeInsets.all(20),
            child: Icon(
              Icons.check,
              color: BrandColors.grey,
            ),
          )
      ),
    );
  }

  void show(BuildContext context) {



    showRoundedModalBottomSheet(
      radius: 20.0,
      color: Colors.white,
      dismissOnTap: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(bottom: 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildListItem(
                  icon: Icons.person,
                  text: Localization().getValue(Localization().activeMembers),
                  membersFilterMode: MembersFilterMode.showActive
              ),
              _buildListItem(
                  icon: Icons.block,
                  text: Localization().getValue(Localization().blockedMembers),
                  membersFilterMode: MembersFilterMode.showBlocked
              ),
              _buildListItem(
                  icon: Icons.delete,
                  text: Localization().getValue(Localization().deletedMembers),
                  membersFilterMode: MembersFilterMode.showDeleted
              )
            ],
          ),
        );
      },
    );

  }


}
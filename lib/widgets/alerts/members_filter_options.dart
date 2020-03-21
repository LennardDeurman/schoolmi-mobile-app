import 'package:flutter/material.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/cells/base_cell.dart';
import 'package:schoolmi/widgets/labels/regular.dart';

class MembersFilterDialog {

  static const int activeMembers = 1;
  static const int blockedMembers = 2;
  static const int deletedMembers = 3;

  Function(int) onOptionSelected;
  int selectedOption;


  MembersFilterDialog ({this.onOptionSelected,  this.selectedOption });



  Widget _buildListItem({ IconData icon, String text, int filterCode }) {
    return BaseCell(
      leading: Icon(icon),
      columnWidgets: <Widget>[
        RegularLabel(
          title: text,
        )
      ],
      onPressed: () {
        onOptionSelected(filterCode);
      },
      trailing: Visibility(
        visible: selectedOption == filterCode,
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
                  filterCode: 1
                ),
                _buildListItem(
                    icon: Icons.block,
                    text: Localization().getValue(Localization().blockedMembers),
                    filterCode: 2
                ),
                _buildListItem(
                    icon: Icons.delete,
                    text: Localization().getValue(Localization().deletedMembers),
                    filterCode: 3
                )
            ],
          ),
        );
      },
    );

  }


}
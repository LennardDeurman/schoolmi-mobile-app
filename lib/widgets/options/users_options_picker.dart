import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/widgets/options/filter_options_bottomsheet.dart';

class UserOptionCell extends StatelessWidget {

  final String title;
  final String subtitle;
  final Widget subtitleWidget;
  final bool isSelected;
  final Function onPressed;

  UserOptionCell ({ this.title, this.subtitle, this.subtitleWidget, this.isSelected, this.onPressed });

  @override
  Widget build(BuildContext context) {
    return Material(child: InkWell(child: Container(
      padding: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20
      ),
      child: Row(
        children: <Widget>[
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TitleLabel(
                color: BrandColors.darkGrey,
                title: title,
              ),
              SizedBox(
                height: 5,
              ),
              subtitleWidget ?? RegularLabel(
                  color: BrandColors.grey,
                  title: subtitle,
                  customSize: 13
              )
            ],
          )),
          Visibility(
              visible: isSelected,
              child: Icon(Icons.check_circle, color: BrandColors.green)
          )
        ],
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1,
                  color: BrandColors.blueGrey
              )
          )
      ),
    ), onTap: onPressed));
  }
}

class UsersOptionsPicker extends StatefulWidget {

  final FilterOptionsManager filterOptionsManager;
  final Map<int, String> hintConfig;

  UsersOptionsPicker (this.filterOptionsManager, { @required this.hintConfig });

  @override
  State<StatefulWidget> createState() {
    return UsersOptionsPickerState();
  }

}


class UsersOptionsPickerState extends State<UsersOptionsPicker> {

  void _setSelected(int id) {
    setState(() {
      widget.filterOptionsManager.usersSelection.selectedUsersOption = id;
    });
  }

  void _onEveryonePressed(BuildContext context) {
    _setSelected(UsersSelection.everyone);
  }

  void _onSpecificUsersPressed(BuildContext context) {
    _setSelected(UsersSelection.specificUsers);
  }

  void _onSpecificRolesPressed(BuildContext context) {
    _setSelected(UsersSelection.specificRoles);
  }

  String get everyoneHint {
    return widget.hintConfig[UsersSelection.everyone];
  }

  String get specificRolesHint {
    return widget.hintConfig[UsersSelection.specificRoles];
  }

  String get specificUsersHint {
    return widget.hintConfig[UsersSelection.specificUsers];
  }

  Widget buildEveryoneCell() {
    return UserOptionCell(
        title: Localization().getValue(Localization().everyone),
        subtitle: everyoneHint,
        isSelected: widget.filterOptionsManager.usersSelection.isSelected(UsersSelection.everyone),
        onPressed: () {
          _onEveryonePressed(context);
        }
    );
  }

  Widget buildSpecificRolesCell() {
    return UserOptionCell(
        title: Localization().getValue(Localization().specificRoles),
        subtitle: specificRolesHint,
        isSelected: widget.filterOptionsManager.usersSelection.isSelected(UsersSelection.specificRoles),
        onPressed: () {
          _onSpecificRolesPressed(context);
        }
    );
  }

  Widget buildSpecificUsersCell() {
    return UserOptionCell(
        title: Localization().getValue(Localization().specificUsers),
        subtitle: specificUsersHint,
        isSelected: widget.filterOptionsManager.usersSelection.isSelected(UsersSelection.specificUsers),
        onPressed: () {
          _onSpecificUsersPressed(context);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: 10
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: TitleLabel(
              title: Localization().getValue(Localization().fromWhomQuestions),
              size: TitleSize.medium,
            ),
            padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildEveryoneCell(),
              buildSpecificRolesCell(),
              buildSpecificUsersCell()
            ],
          )
        ],
      ),
    );
  }
}
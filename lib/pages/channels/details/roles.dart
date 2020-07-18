import 'package:flutter/material.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/managers/channels/roles.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/network/models/role.dart';
import 'package:schoolmi/widgets/lists/channels/details/roles.dart';

class PickRolesPage extends StatelessWidget {

  final RolesManager rolesManager;
  final Function(Role) onRolePressed;
  final Role selectedRole;

  PickRolesPage (this.rolesManager, { this.onRolePressed, this.selectedRole });

  void _showHelp(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
          title: TitleLabel(
            title: Localization().getValue(Localization().help),
          ),
          content: RegularLabel(
            title: Localization().getValue(Localization().rolesHelp),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(Localization().getValue(Localization().okay)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ]
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TitleLabel(title: Localization().getValue(Localization().assignRole), color: Colors.white),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () {
                _showHelp(context);
              },
            )
          ],
        ),
        body: Center(
          child: RolesListView(rolesManager, onRolePressed: onRolePressed, selectedRole: selectedRole),
        )
    );
  }

  static void show({ BuildContext context, Role selectedRole, RolesManager rolesManager, Function(Role) onRolePressed }) {
    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
      return PickRolesPage(rolesManager, onRolePressed: onRolePressed, selectedRole: selectedRole);
    }));
  }

}
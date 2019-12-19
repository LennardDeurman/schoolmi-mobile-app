import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/models/data/member.dart';
import 'package:schoolmi/managers/members.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/widgets/cells/base_cell.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:flutter/material.dart';

class MembersEditingDialog {


  final Member member;
  final MembersManager manager;

  MembersEditingDialog ({ this.member, this.manager });


  Widget _buildAdminStatusActionWidget(BuildContext context) {
    return BaseCell(
      leading: member.isAdmin ? Icon(Icons.undo) : Icon(Icons.supervisor_account),
      columnWidgets: <Widget>[
        RegularLabel(
          title: member.isAdmin ?  Localization().getValue(Localization().removeAdminRights) : Localization().getValue(Localization().makeUserAdmin),
        )
      ],
      onPressed: () {
        bool newAdminState = !member.isAdmin;
        member.isAdmin = newAdminState;
        manager.executeAsync(manager.updateMember(member)).catchError((e) {
          member.isAdmin = !newAdminState;
        }).whenComplete((){
          Navigator.pop(context);
        });
      },

    );
  }

  Widget _buildRemoveMemberWidget(BuildContext context) {
    return BaseCell(
      leading: Icon(Icons.delete),
      columnWidgets: <Widget>[
        RegularLabel(
          title: Localization().getValue(Localization().removeUserFromChannel),
        )
      ],
      onPressed: () {
        member.isDeleted = true;
        manager.executeAsync(manager.updateMember(member)).catchError((e) {
          member.isDeleted = false;
        }).whenComplete((){
          Navigator.pop(context);
        });
      },
    );
  }



  void show(BuildContext context) {
    showRoundedModalBottomSheet(
      radius: 20.0,
      color: Colors.white,
      dismissOnTap: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(bottom: 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAdminStatusActionWidget(context),
              _buildRemoveMemberWidget(context)
            ],
          ),
        );
      },
    );
  }




}
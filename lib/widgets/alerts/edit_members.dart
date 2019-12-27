import 'package:schoolmi/models/data/member.dart';
import 'package:schoolmi/managers/members.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/alerts/snackbar.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/widgets/cells/base_cell.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:flutter/material.dart';

class MembersEditingDialog {


  final Member member;
  final MembersManager manager;

  MembersEditingDialog ({ this.member, this.manager });

  Future _executeAction(BuildContext context, { Function onPreExecute, Function onFailed }) {

    if (onPreExecute != null) {
      onPreExecute();
    }

    manager.uploadObject = member;
    return manager.saveUploadObjects().catchError((e) {
      if (onFailed != null) {
        onFailed();
      }
      showSnackBar(message: Localization().getValue(Localization().errorUnexpected), isError: true, buildContext: context);
    }).whenComplete((){
      Navigator.pop(context);
    });
  }

  Widget _buildAdminStatusActionWidget(BuildContext context) {
    return BaseCell(
      leading: member.isAdmin ? Icon(Icons.undo) : Icon(Icons.supervisor_account),
      columnWidgets: <Widget>[
        RegularLabel(
          title: member.isAdmin ?  Localization().getValue(Localization().removeAdminRights) : Localization().getValue(Localization().makeUserAdmin),
        )
      ],
      onPressed: () {
        bool currentAdminState = member.isAdmin;
        bool newAdminState = !member.isAdmin;
        _executeAction(context, onPreExecute: () {
          member.isAdmin = newAdminState;
        }, onFailed: () {
          member.isAdmin = currentAdminState;
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
        _executeAction(context, onPreExecute: () {
          member.isDeleted = true;
        }, onFailed: () {
          member.isDeleted = false;
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
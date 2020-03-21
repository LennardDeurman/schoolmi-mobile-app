import 'package:schoolmi/models/data/member.dart';
import 'package:schoolmi/managers/members.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/alerts/snackbar.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/widgets/cells/base_cell.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:flutter/material.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:sprintf/sprintf.dart';

class MembersEditingDialog {


  final Member member;
  final MembersManager manager;
  final Function(Member) onModified;
  final GlobalKey<ScaffoldState> scaffoldKey;

  MembersEditingDialog ({ this.member, this.manager, this.scaffoldKey, this.onModified });

  Future _executeAction(BuildContext context, { Function onPreExecute, Function onFailed }) {

    if (onPreExecute != null) {
      onPreExecute();
    }

    manager.uploadObject = member;
    if (onModified != null) {
      onModified(member);
    }
    Navigator.pop(context);
    return manager.saveUploadObjects().catchError((e) {
      if (onFailed != null) {
        onFailed();
      }
      showSnackBar(message: Localization().getValue(Localization().errorUnexpected), isError: true, scaffoldKey: scaffoldKey);
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

  Widget _buildUndoDeletedWidget(BuildContext context) {
    return BaseCell(
      leading: Icon(Icons.undo),
      columnWidgets: <Widget>[
        RegularLabel(
          title: Localization().getValue(Localization().undoDeletedFromChannel),
        )
      ],
      onPressed: () {
        _executeAction(context, onPreExecute: () {
          member.isDeleted = false;
        }, onFailed: () {
          member.isDeleted = true;
        });
      },
    );
  }

  Widget _buildUnblockWidget(BuildContext context) {
    return BaseCell(
      leading: Icon(Icons.undo),
      columnWidgets: <Widget>[
        RegularLabel(
          title: Localization().getValue(Localization().unblockFromChannel),
        )
      ],
      onPressed: () {
        _executeAction(context, onPreExecute: () {
          member.blocked = false;
        }, onFailed: () {
          member.blocked = true;
        });
      },
    );
  }

  Widget _buildBlockMemberWidget(BuildContext context) {
    return BaseCell(
      leading: Icon(Icons.block),
      columnWidgets: <Widget>[
        RegularLabel(
          title: Localization().getValue(Localization().blockUserForChannel),
        )
      ],
      onPressed: () {
        
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(
            title: TitleLabel(title: Localization().getValue(Localization().blockUserForChannel)),
            content: RegularLabel(
              title: sprintf(Localization().getValue(Localization().blockUserInfo), [member.email, manager.channel.name])
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(Localization().getValue(Localization().confirm)),
                onPressed: () {
                  Navigator.of(context).pop();

                  _executeAction(context, onPreExecute: () {
                    member.blocked = true;
                  }, onFailed: () {
                    member.blocked = false;
                  });
                },
              ),
              FlatButton(
                child: Text(Localization().getValue(Localization().cancel)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
        

      },
    );
  }


  List<Widget> buildWidgets(BuildContext context) {
    List<Widget> widgets = [];
    if (member.blocked) {
      widgets.add(_buildUnblockWidget(context));
    }

    if (member.isDeleted) {
      widgets.add(_buildUndoDeletedWidget(context));
    }

    if (!member.isDeleted && !member.blocked) {
      widgets.addAll([
        _buildAdminStatusActionWidget(context),
        _buildRemoveMemberWidget(context),
        _buildBlockMemberWidget(context)
      ]);
    }
    return widgets;
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
            children: buildWidgets(context),
          ),
        );
      },
    );
  }




}
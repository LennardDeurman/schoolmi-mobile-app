import 'package:schoolmi/managers/roles.dart';
import 'package:schoolmi/models/data/member.dart';
import 'package:schoolmi/managers/members.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/models/data/role.dart';
import 'package:schoolmi/pages/roles.dart';
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

  Widget _buildRoleWidget(BuildContext context) {
    return BaseCell(
      leading: Icon(Icons.person),
      columnWidgets: <Widget>[
        RegularLabel(
          title: Localization().getValue(Localization().assignRole),
        )
      ],
      onPressed: () {
        Navigator.pop(context);
        RolesManager rolesManager = manager.homeManager.channelDetailsManager.rolesManager;
        PickRolesPage.show(
          context: context,
          rolesManager: rolesManager,
          selectedRole: member.role,
          onRolePressed: (Role role) async {
            Navigator.pop(context);

            Role oldRole = member.role;
            if (oldRole == role) {
              role = null;
            }

            try {
              member.role = role;
              onModified(member);



              Role activeRole = role;
              if (role != null) {
                if (role.id == null) {
                  rolesManager.uploadObject = role;
                  List<Role> roles = await rolesManager.saveUploadObjects();
                  activeRole = roles.first;
                }
              }

              member.role = activeRole;
              manager.uploadObject = member;
              await manager.saveUploadObjects();
            } catch (e) {
              member.role = oldRole;
              onModified(member);
              showSnackBar(message: Localization().getValue(Localization().errorUnexpected), isError: true, scaffoldKey: scaffoldKey);
            }





          }
        );
      },
    );
  }


  List<Widget> buildWidgets(BuildContext context) {

    if (member.isCurrentUser) {
      return [
        _buildRoleWidget(context)
      ];
    }

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
        _buildBlockMemberWidget(context),
        _buildRoleWidget(context)
      ]);
    }

    return widgets;
  }



  void show(BuildContext parentContext) {

    showRoundedModalBottomSheet(
      radius: 20.0,
      color: Colors.white,
      dismissOnTap: false,
      context: parentContext,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(bottom: 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: buildWidgets(parentContext),
          ),
        );
      },
    );
  }




}
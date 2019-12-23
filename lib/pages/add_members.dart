import 'package:flutter/material.dart';
import 'package:schoolmi/managers/members.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/alerts/snackbar.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/widgets/listviews/add_members.dart';
import 'package:schoolmi/widgets/add_members_form.dart';

class AddMembersPage extends StatefulWidget {

  final AddMembersManager manager;

  AddMembersPage (this.manager);

  @override
  State<StatefulWidget> createState() {
    return _AddMembersPageState();
  }
}

class _AddMembersPageState extends State<AddMembersPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<AddMembersFormState> _addMembersFormKey = GlobalKey<AddMembersFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done, color: Colors.white),
        onPressed: () {
          widget.manager.saveUploadObjects().then((_) {
            Navigator.pop(context);
          }).catchError((e) {
            showSnackBar(message: Localization().getValue(Localization().errorUnexpected), isError: true, buildContext: context);
          });
        },
      ),
      appBar: AppBar(
        title: TitleLabel(
          title: Localization().getValue(Localization().addMember),
          color: Colors.white,
        ),
        actions: <Widget>[
          Visibility(child: FlatButton(
              child: RegularLabel(
                title: Localization().getValue(Localization().cancel),
                color: Colors.white,
              ),
              onPressed: () {
                _addMembersFormKey.currentState.focusNode.unfocus();
              }
          ), visible: _addMembersFormKey.currentState.focusNode.hasFocus)
        ],
      ),
      body:  AddMembersListView(
          channel: widget.manager.membersManager.channel,
          emails: widget.manager.emails,
          formBuilder: () {
            return AddMembersForm(
                key: _addMembersFormKey,
                onEditingComplete: (String email) {
                  setState(() {
                    widget.manager.add(email);
                  });
                }
            );
          },
          onRemovePressed: (String email) {
            setState(() {
              widget.manager.remove(email);
            });
          }
      ),
    );
  }

}
import 'package:flutter/material.dart';
import 'package:schoolmi/managers/members.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/alerts/snackbar.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/widgets/listviews/add_members.dart';
import 'package:schoolmi/widgets/add_members_form.dart';
import 'package:scoped_model/scoped_model.dart';

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

  void _addMember(String email) {

    setState(() {
      widget.manager.add(email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: ScopedModel<AddMembersManager>(
        model: widget.manager,
        child: ScopedModelDescendant<AddMembersManager>(
          builder: (BuildContext context, Widget widget, AddMembersManager manager) {
            return FloatingActionButton(
              child: manager.isLoading ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white))) : Icon(Icons.done, color: Colors.white),
              onPressed: () {
                manager.saveUploadObjects().then((_) {
                  Navigator.pop(context);
                  this.widget.manager.membersManager.uploadObjects = [];
                }).catchError((e) {
                  showSnackBar(message: Localization().getValue(Localization().errorUnexpected), isError: true, scaffoldKey: _scaffoldKey);
                });
              },
            );
          }
        )
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
          ), visible: _addMembersFormKey.currentState != null ? _addMembersFormKey.currentState.focusNode.hasFocus : false)
        ],
      ),
      body:  AddMembersListView(
          channel: widget.manager.membersManager.channel,
          emails: widget.manager.emails,
          formBuilder: () {
            return AddMembersForm(
                key: _addMembersFormKey,
                onEditingComplete: _addMember
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
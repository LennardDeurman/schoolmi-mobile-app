import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:schoolmi/managers/channels/members.dart';
import 'package:schoolmi/widgets/forms/add_members.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/widgets/extensions/messages.dart';
import 'package:schoolmi/widgets/lists/add_members.dart';
import 'package:schoolmi/localization/localization.dart';


class AddMembersPage extends StatefulWidget {

  final MembersManager membersManager;

  AddMembersPage (this.membersManager);

  @override
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }

}

class AddMembersPageState extends State<AddMembersPage> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode emailInputFocusNode = FocusNode();

  void saveObjects() {
    widget.membersManager.saveUploadObjects().then((_) {
      Navigator.pop(context);
    }).catchError((e) {
      showSnackBar(message: Localization().getValue(Localization().errorUnexpected), isError: true, scaffoldKey: scaffoldKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: ScopedModel<MembersManager>(
          model: widget.membersManager,
          child: ScopedModelDescendant<MembersManager>(
              builder: (BuildContext context, Widget widget, MembersManager manager) {
                return FloatingActionButton(
                  child: manager.isLoading ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white))) : Icon(Icons.done, color: Colors.white),
                  onPressed: saveObjects,
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
                emailInputFocusNode.unfocus();
              }
          ), visible: emailInputFocusNode.hasFocus)
        ],
      ),
      body:  AddMembersListView(
          channel: widget.membersManager.channel,
          emails: widget.membersManager.emails,
          formBuilder: () {
            return AddMembersForm(
                onEditingComplete: (String email) {
                  widget.membersManager.add(email);
                }
            );
          },
          onRemovePressed: (String email) {
            widget.membersManager.remove(email);
          }
      ),
    );
  }

}
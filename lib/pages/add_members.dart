import 'package:flutter/material.dart';
import 'package:schoolmi/managers/members.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/widgets/listviews/add_members.dart';
import 'package:schoolmi/widgets/add_members_form.dart';
import 'package:scoped_model/scoped_model.dart';

class AddMembersPage extends StatefulWidget {

  final MembersManager manager;

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
    return ScopedModel<MembersManager>(
      model: widget.manager,
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done, color: Colors.white),
          onPressed: () {
            widget.manager.saveUploadObjects().catchError((e) {
              //show snackbar;
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
        body:  Center(
          child: ScopedModelDescendant(
              builder: (BuildContext context, Widget widget, MembersManager manager) {
                return AddMembersListView(
                  channel: manager.channel,
                  emails: manager.uploadObjects,
                  formBuilder: () {
                    return AddMembersForm(
                      key: _addMembersFormKey,
                      onEditingComplete: (String email) {
                        setState(() {
                          manager.uploadObjects.add(email);
                        });
                      }
                    );
                  },
                  onRemovePressed: (String email) {
                    setState(() {
                      manager.uploadObjects.remove(email);
                    });
                  }
                );
              }
          ),
        ),
      ),
    );
  }

}
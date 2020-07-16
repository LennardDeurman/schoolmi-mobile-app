import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:schoolmi/managers/channels/members.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/widgets/extensions/textfields.dart';
import 'package:schoolmi/widgets/extensions/messages.dart';
import 'package:schoolmi/widgets/lists/add_members.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/extensions/validators.dart';


class AddMembersPage extends StatefulWidget {

  final MembersManager membersManager;

  AddMembersPage (this.membersManager);

  @override
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
  
}

class AddMembersForm extends StatelessWidget {


  final Function(String email) onEditingComplete;
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AddMembersForm ({ @required this.onEditingComplete, this.focusNode, Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    width: 1,
                    color: BrandColors.blueGrey
                ),
                top: BorderSide(
                    width: 1,
                    color: BrandColors.blueGrey
                )
            )
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              RegularLabel(
                title: Localization().getValue(Localization().addUserMessage),
              ),
              SizedBox(
                height: 30,
              ),
              DefaultTextField(
                hint: Localization().getValue(Localization().email),
                validator: Validators.emailValidator,
                textFieldType: TextFieldType.filled,
                onEditingComplete: () {
                  formKey.currentState.save();
                  if (formKey.currentState.validate()) {
                    onEditingComplete(textController.text);
                    textController.clear();
                  }

                },
                focusNode: focusNode,
                controller: textController,
              )
            ],
          ),
        ));
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
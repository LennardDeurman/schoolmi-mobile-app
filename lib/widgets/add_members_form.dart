import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/extensions/validators.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/widgets/textfield.dart';

class AddMembersForm extends StatefulWidget {


  final Function(String email) onEditingComplete;

  AddMembersForm ({ @required this.onEditingComplete, Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddMembersFormState();
  }

}

//Public, for in case data is required

class AddMembersFormState extends State<AddMembersForm> {

  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                    textController.clear();
                    widget.onEditingComplete(textController.text);
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
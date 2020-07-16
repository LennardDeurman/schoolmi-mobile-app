import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/extensions/validators.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/widgets/extensions/textfields.dart';
import 'package:schoolmi/localization/localization.dart';

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
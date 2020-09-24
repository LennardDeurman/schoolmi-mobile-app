import 'package:flutter/material.dart';
import 'package:schoolmi/widgets/extensions/textfields.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/extensions/validators.dart';

class UserFormUI {

  static Key emailKey = Key("email");

  Widget firstNameTextField({ Function onSaved }) {
    return DefaultTextField(
      title: Localization().getValue(Localization().firstName),
      hint: Localization().getValue(Localization().firstNameHint),
      textCapitalization: TextCapitalization.words,
      onSaved: onSaved,
      validator: Validators.notEmptyValidator,
    );
  }

  Widget lastNameTextField({ Function onSaved }) {
    return DefaultTextField(
      title:  Localization().getValue(Localization().lastName),
      hint: Localization().getValue(Localization().lastNameHint),
      textCapitalization: TextCapitalization.words,
      onSaved: onSaved,
      validator: Validators.notEmptyValidator,
    );
  }

  Widget emailTextField({ Function onSaved }) {
    return  DefaultTextField(
      title: Localization().getValue(Localization().email),
      key: emailKey,
      hint: Localization().getValue(Localization().emailHint),
      textInputType: TextInputType.emailAddress,
      onSaved: onSaved,
      validator: Validators.emailValidator,
    );
  }

  Widget usernameTextField({ Function onSaved }) {
    return  DefaultTextField(
      title: Localization().getValue(Localization().username),
      hint: Localization().getValue(Localization().usernameHint),
      onSaved: onSaved,
      validator: Validators.usernameValidator,
    );
  }

}

class UserInfoForm extends StatelessWidget with UserFormUI {

  final GlobalKey<FormState> formKey;
  final Function(String) onFirstNameSaved;
  final Function(String) onLastNameSaved;
  final Function(String) onUsernameSaved;

  UserInfoForm ({ this.formKey, this.onFirstNameSaved, this.onLastNameSaved, this.onUsernameSaved });


  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          firstNameTextField(onSaved: onFirstNameSaved),
          SizedBox(height: 20.0),
          lastNameTextField(onSaved: onLastNameSaved),
          SizedBox(height: 20.0),
          usernameTextField(onSaved: onUsernameSaved)
        ],
      ),
    );
  }

}
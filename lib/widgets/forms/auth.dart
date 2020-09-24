import 'package:flutter/material.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/widgets/forms/userinfo.dart';
import 'package:schoolmi/widgets/extensions/textfields.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/widgets/extensions/hyperlinks.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/extensions/validators.dart';

abstract class AuthForm extends StatelessWidget with UserFormUI {

  final GlobalKey<FormState> formKey;
  final Function(String) onPasswordSaved;
  final Function(String) onEmailSaved;
  final Function(String) onUsernameSaved;
  final Function(String) onFirstNameSaved;
  final Function(String) onLastNameSaved;

  static Key passwordKey = Key("password");

  AuthForm ({ this.formKey, this.onPasswordSaved, this.onEmailSaved, this.onUsernameSaved, this.onFirstNameSaved,
    this.onLastNameSaved
  });


  Widget passwordTextField({ Function onSaved }) {
    return  DefaultTextField(
      title: Localization().getValue(Localization().password),
      key: passwordKey,
      hint: Localization().getValue(Localization().passwordHint),
      obscureText: true,
      onSaved: onSaved,
      validator: Validators.passwordValidator,
    );
  }


  Widget forgotPasswordLabel({ Function onPressed }) {
    return Align(
      alignment: Alignment.centerRight,
      child: Hyperlink(onPressed: onPressed, builder: (bool isHighlighted, Color currentColor) {
        return RegularLabel(
          title: Localization().getValue(Localization().forgotPassword),
          size: LabelSize.small,
          color: currentColor,
        );
      }),
    );
  }

}


class LoginForm extends AuthForm {

  LoginForm ({
    GlobalKey<FormState> formKey, Function onEmailSaved, Function onPasswordSaved
  }) : super(
      formKey: formKey, onEmailSaved: onEmailSaved, onPasswordSaved: onPasswordSaved
  );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          emailTextField(onSaved: onEmailSaved),
          SizedBox(height: 20.0),
          passwordTextField(onSaved: onPasswordSaved),
          SizedBox(height: 30.0),
          forgotPasswordLabel(),
        ],
      ),
    );
  }

}

class ForgotPasswordForm extends AuthForm {

  ForgotPasswordForm ({
    GlobalKey<FormState> formKey, Function onEmailSaved
  }) : super(
      formKey: formKey, onEmailSaved: onEmailSaved
  );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          emailTextField(onSaved: onEmailSaved)
        ],
      ),
    );
  }

}

class RegistrationForm extends AuthForm {

  RegistrationForm ({ GlobalKey<FormState> formKey,
    Function onFirstNameSaved, Function onLastNameSaved,
    Function onUsernameSaved, Function onEmailSaved,
    Function onPasswordSaved
  }) : super(
      formKey: formKey, onFirstNameSaved: onFirstNameSaved,
      onLastNameSaved: onLastNameSaved, onUsernameSaved: onUsernameSaved, onEmailSaved: onEmailSaved,
      onPasswordSaved: onPasswordSaved
  );

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
          usernameTextField(onSaved: onUsernameSaved),
          SizedBox(height: 20.0),
          emailTextField(onSaved: onEmailSaved),
          SizedBox(height: 20.0),
          passwordTextField(onSaved: onPasswordSaved),
        ],
      ),
    );
  }

}

class PasswordResetSentForm extends StatelessWidget {

  final Function onLoginPressed;

  PasswordResetSentForm ({ this.onLoginPressed });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20.0),
          RegularLabel(title: Localization().getValue(Localization().resetEmailDescription)),
          SizedBox(height: 10.0),
          FlatButton(
            padding: EdgeInsets.all(0.0),
            child: TitleLabel(
              title: Localization().getValue(Localization().login),
              size: TitleSize.regular,
              color: BrandColors.green,
            ),
            onPressed: onLoginPressed,
          ),
        ],
      ),
    );
  }

}

class VerifyEmailForm extends StatelessWidget {

  final Function onLoginPressed;

  VerifyEmailForm ({ this.onLoginPressed });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20.0),
          RegularLabel(title: Localization().getValue(Localization().verifyEmailDescription)),
          SizedBox(height: 10.0),
          FlatButton(
            padding: EdgeInsets.all(0.0),
            child: TitleLabel(
              title: Localization().getValue(Localization().login),
              size: TitleSize.regular,
              color: BrandColors.green,
            ),
            onPressed: onLoginPressed,
          ),
        ],
      ),
    );
  }

}
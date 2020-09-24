import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schoolmi/widgets/forms/auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/extensions/errorcodes.dart';
import 'package:schoolmi/extensions/validators.dart';
import 'package:schoolmi/extensions/exceptions.dart';
import 'package:schoolmi/managers/auth.dart';
import 'package:schoolmi/widgets/brand/buildings.dart';
import 'package:schoolmi/widgets/extensions/buttons.dart';
import 'package:schoolmi/widgets/extensions/textfields.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/widgets/extensions/messages.dart';
import 'package:schoolmi/widgets/extensions/hyperlinks.dart';
import 'package:schoolmi/widgets/brand/logo.dart';
import 'package:schoolmi/widgets/extensions/shadows.dart';
import 'package:schoolmi/localization/localization.dart';


class AuthPage extends StatefulWidget {


  //Used for testing
  static Key authButtonKey = Key("authButton");


  AuthPage();
  @override
  State<StatefulWidget> createState() {
    return AuthPageState();
  }
}

class AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  AuthManager _authManager;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _forgotPasswordFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _authManager = AuthManager();
    _authManager.executeAsync(_authManager.initialize());
    super.initState();
  }

  void onEmailSaved(String value) {
    _authManager.email = value;
  }

  void onPasswordSaved(String value) {
    _authManager.password = value;
  }

  void onFirstNameSaved(String value) {
    _authManager.firstName = value;
  }

  void onLastNameSaved(String value) {
    _authManager.lastName = value;
  }

  void onUsernameSaved(String value) {
    _authManager.username = value;
  }

  String _getActionTitle() {
    if (_authManager.authActionState != AuthActionState.login && _authManager.authActionState != AuthActionState.register) {
      return Localization().getValue(Localization().confirm);
    }
    return _getTitle();
  }

  String _getTitle() {
    if (_authManager.authActionState == AuthActionState.login) {
      return Localization().getValue(Localization().login);
    } else if (_authManager.authActionState == AuthActionState.register) {
      return Localization().getValue(Localization().register);
    } else if (_authManager.authActionState == AuthActionState.verifyEmail) {
      return Localization().getValue(Localization().verifyEmail);
    } else if (_authManager.authActionState == AuthActionState.forgotPassword) {
      return Localization().getValue(Localization().forgotPassword);
    } else if (_authManager.authActionState == AuthActionState.passwordResetSent) {
      return Localization().getValue(Localization().resetEmailSent);
    }
    return "";
  }

  Widget _buildAuthBody() {
    if (_authManager.authActionState == AuthActionState.login) {
      return LoginForm(
          formKey: _loginFormKey,
          onEmailSaved: onEmailSaved,
          onPasswordSaved: onPasswordSaved
      );
    } else if (_authManager.authActionState == AuthActionState.register) {
      return RegistrationForm(
          formKey: _registerFormKey,
          onEmailSaved: onEmailSaved,
          onPasswordSaved: onPasswordSaved,
          onFirstNameSaved: onFirstNameSaved,
          onLastNameSaved: onLastNameSaved,
          onUsernameSaved: onUsernameSaved
      );
    } else if (_authManager.authActionState == AuthActionState.verifyEmail) {
      return VerifyEmailForm(
        onLoginPressed: () {
          _authManager.refreshLoginState().catchError((e) {
            if (e is LoginException) {
              LoginException loginException = e;
              switch (loginException.loginError) {
                case LoginError.noUserActive:
                  _authManager.authActionState = AuthActionState.login;
                  break;
                case LoginError.emailNotVerified:
                  showSnackBar(message:  Localization().getValue(Localization().verifyEmail), isError: true, scaffoldKey: _scaffoldKey);
                  break;
              }
            }
          });
        },
      );
    } else if (_authManager.authActionState == AuthActionState.forgotPassword) {
      return ForgotPasswordForm(
          formKey: _forgotPasswordFormKey,
          onEmailSaved: onEmailSaved
      );
    } else if (_authManager.authActionState == AuthActionState.passwordResetSent) {
      return PasswordResetSentForm(
        onLoginPressed: () {
          _authManager.authActionState = AuthActionState.login;
        },
      );
    }
    return Container(
      child: Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildAuthForm() {

    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 30.0, bottom: 30.0),
            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 15.0),
            decoration: shadowBox(
              blurRadius: 70.0,
              yOffset: 23.0,
              xOffset: 0.0,
              alpha: 0.1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleLabel(
                  size: TitleSize.big,
                  title: _getTitle(),
                ),
                _buildAuthBody(),
              ],
            ),
          ),
          _buildAuthButton(),
        ],
      ),
    );
  }

  Widget _buildAuthButton() {
    if (_authManager.authActionState == AuthActionState.login ||
        _authManager.authActionState == AuthActionState.register ||
        _authManager.authActionState == AuthActionState.forgotPassword
    ) {
      return Align(
        alignment: Alignment.centerRight,
        child: DefaultButton(
          key: AuthPage.authButtonKey,
          child: RegularLabel(title: _getActionTitle(), color: Colors.white, fontWeight: FontWeight.bold),
          isLoading: _authManager.isLoading,
          onPressed: _authButtonPressed,
        ),
      );
    }
    return Container();
  }

  Widget _buildSecondaryAccountButton() {
    if (_authManager.authActionState == AuthActionState.login || _authManager.authActionState == AuthActionState.register
        || _authManager.authActionState == AuthActionState.forgotPassword
    ) {
      return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RegularLabel(
              title: _authManager.authActionState == AuthActionState.login ? Localization().getValue(Localization().noAccount) :  Localization().getValue(Localization().alreadyAccount),
              size: LabelSize.medium,
            ),
            FlatButton(
              padding: EdgeInsets.only(left: 5.0),
              child: TitleLabel(
                title: _authManager.authActionState == AuthActionState.login ? Localization().getValue(Localization().register) : Localization().getValue(Localization().login),
                size: TitleSize.regular,
                color: BrandColors.green,
              ),
              onPressed: () {
                if (_authManager.authActionState == AuthActionState.login) {
                  _authManager.authActionState = AuthActionState.register;
                } else {
                  _authManager.authActionState = AuthActionState.login;
                }
              },
            )
          ],
        ),
      );
    }
    return Container();
  }

  Widget _buildBody() {
    return Center(
      child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
          child: Container(
              child: ScopedModelDescendant<AuthManager>(
                builder: (context, child, model) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Logo(),
                      _buildAuthForm(),
                      _buildSecondaryAccountButton(),
                    ],
                  );
                },
              )
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AuthManager>(
        model: _authManager,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              Buildings(),
              _buildBody(),
            ],
          ),
        ));
  }


  void _authButtonPressed() {
    if (_authManager.authActionState == AuthActionState.login) {
      if (!_loginFormKey.currentState.validate()) return;
      _loginFormKey.currentState.save();
      _authManager.executeAsync(_authManager.login()).catchError((e) {
        if (e is Exception) {
          showSnackBar(scaffoldKey: _scaffoldKey, message: ErrorCode.fromException(e).toString(), isError: true);
        }
      });
    } else if (_authManager.authActionState == AuthActionState.register) {
      if (!_registerFormKey.currentState.validate()) return;
      _registerFormKey.currentState.save();
      _authManager.executeAsync(_authManager.register()).catchError((e) {
        if (e is Exception) {
          showSnackBar(scaffoldKey: _scaffoldKey, message: ErrorCode.fromException(e).toString(), isError: true);
        }
      });
    } else if (_authManager.authActionState == AuthActionState.forgotPassword) {
      if (!_forgotPasswordFormKey.currentState.validate()) return;
      _forgotPasswordFormKey.currentState.save();
      _authManager.executeAsync(_authManager.sendPasswordForgotEmail()).catchError((e) {
        if (e is Exception) {
          showSnackBar(scaffoldKey: _scaffoldKey, message: ErrorCode.fromException(e).toString(), isError: true);
        }
      });
    }
  }



}

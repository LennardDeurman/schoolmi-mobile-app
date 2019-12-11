import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/extensions/errorcodes.dart';
import 'package:schoolmi/extensions/validators.dart';
import 'package:schoolmi/extensions/exceptions.dart';
import 'package:schoolmi/managers/auth.dart';
import 'package:schoolmi/widgets/alerts/snackbar.dart';
import 'package:schoolmi/widgets/buildings.dart';
import 'package:schoolmi/widgets/button.dart';
import 'package:schoolmi/widgets/textfield.dart';
import 'package:schoolmi/widgets/logo.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/widgets/highlighted_widget.dart';
import 'package:schoolmi/styles/shadow_bg.dart';
import 'package:schoolmi/localization/localization.dart';


class AuthPage extends StatefulWidget {
  AuthPage();
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
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

  Widget _buildFirstNameTextField() {
    return DefaultTextField(
      title: Localization().getValue(Localization().firstName),
      hint: Localization().getValue(Localization().firstNameHint),
      textCapitalization: TextCapitalization.words,
      onSaved: (String value) {
        _authManager.firstName = value;
      },
      validator: Validators.notEmptyValidator,
    );
  }

  Widget _buildLastNameTextField() {
    return DefaultTextField(
      title:  Localization().getValue(Localization().lastName),
      hint: Localization().getValue(Localization().lastNameHint),
      textCapitalization: TextCapitalization.words,
      onSaved: (String value) {
        _authManager.lastName = value;
      },
      validator: Validators.notEmptyValidator,
    );
  }

  Widget _buildEmailTextField() {
    return  DefaultTextField(
      title: Localization().getValue(Localization().email),
      hint: Localization().getValue(Localization().emailHint),
      textInputType: TextInputType.emailAddress,
      onSaved: (String value) {
        _authManager.email = value;
      },
      validator: Validators.emailValidator,
    );
  }

  Widget _buildPasswordTextField() {
    return  DefaultTextField(
      title: Localization().getValue(Localization().password),
      hint: Localization().getValue(Localization().passwordHint),
      obscureText: true,
      onSaved: (String value) {
        _authManager.password = value;
      },
      validator: Validators.passwordValidator,
    );
  }

  Widget _buildUsernameTextField() {
    return  DefaultTextField(
      title: Localization().getValue(Localization().username),
      hint: Localization().getValue(Localization().usernameHint),
      onSaved: (String value) {
        _authManager.username = value;
      },
      validator: Validators.usernameValidator,
    );
  }

  Widget _buildForgotPasswordLabel() {
    return Align(
      alignment: Alignment.centerRight,
      child: HighlightedWidget(onPressed: () {
        _authManager.authActionState = AuthActionState.forgotPassword;
      }, renderWidget: (bool isHighlighted, Color currentColor) {
        return RegularLabel(
          title: Localization().getValue(Localization().forgotPassword),
          size: LabelSize.small,
          color: currentColor,
        );
      }),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          _buildEmailTextField(),
          SizedBox(height: 20.0),
          _buildPasswordTextField(),
          SizedBox(height: 30.0),
          _buildForgotPasswordLabel(),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordForm() {
    return Form(
      key: _forgotPasswordFormKey,
      child: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          _buildEmailTextField()
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          _buildFirstNameTextField(),
          SizedBox(height: 20.0),
          _buildLastNameTextField(),
          SizedBox(height: 20.0),
          _buildUsernameTextField(),
          SizedBox(height: 20.0),
          _buildEmailTextField(),
          SizedBox(height: 20.0),
          _buildPasswordTextField(),
        ],
      ),
    );
  }

  Widget _buildPasswordResetSentForm() {
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
            onPressed: () {
              _authManager.authActionState = AuthActionState.login;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyEmailForm() {
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
            onPressed: () {
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
          ),
        ],
      ),
    );
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
      return _buildLoginForm();
    } else if (_authManager.authActionState == AuthActionState.register) {
      return _buildRegisterForm();
    } else if (_authManager.authActionState == AuthActionState.verifyEmail) {
      return _buildVerifyEmailForm();
    } else if (_authManager.authActionState == AuthActionState.forgotPassword) {
      return _buildForgotPasswordForm();
    } else if (_authManager.authActionState == AuthActionState.passwordResetSent) {
      return _buildPasswordResetSentForm();
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
          child: RegularLabel(title: _getActionTitle()),
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

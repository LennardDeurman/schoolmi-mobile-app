import 'dart:async';

import 'package:flutter/material.dart';
import 'package:schoolmi/extensions/errorcodes.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/managers/auth.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/widgets/extensions/buttons.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/widgets/extensions/messages.dart';
import 'package:schoolmi/widgets/forms/userinfo.dart';
import 'package:scoped_model/scoped_model.dart';

class UserInfoDialog extends StatefulWidget {

  final GlobalKey<ScaffoldState> scaffoldKey;

  UserInfoDialog ( { this.scaffoldKey } );

  @override
  State<StatefulWidget> createState() {
    return _UserInfoDialogState();
  }

}

class _UserInfoDialogState extends State<UserInfoDialog> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthManager authManager = AuthManager();

  void onSavePressed() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Completer completer = Completer();
      authManager.saveUserInfo().then((v) {
        UserService().userResult.refreshMyProfile().then((_) {
          if (UserService().userResult.myProfile != null) {
            completer.complete();
          } else {
            completer.completeError(Exception("No user found"));
          }
        }).catchError((e) {
          completer.completeError(e);
        });
      }).catchError((e) {
        completer.completeError(e);
      });

      authManager.executeAsync(
        completer.future.then((v) {
          Navigator.pop(context);
          showSnackBar(
            scaffoldKey: widget.scaffoldKey,
            message: Localization().getValue(Localization().successSaved),
            isError: false
          );
        }).catchError((e) {
          if (e is Exception) {
            showSnackBar(
                scaffoldKey: widget.scaffoldKey,
                message: ErrorCode.fromException(e).toString(),
                isError: true
            );
          }
        })
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: ScopedModel<AuthManager>(
          model: authManager,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TitleLabel(
                title: Localization().getValue(Localization().userInfoWelcomeTitle),
              ),
              RegularLabel(
                title: Localization().getValue(Localization().userInfoWelcomeDescription),
              ),
              UserInfoForm(
                  formKey: formKey,
                  onFirstNameSaved: (value) {
                    authManager.firstName = value;
                  },
                  onLastNameSaved: (value) {
                    authManager.lastName = value;
                  },
                  onUsernameSaved: (value) {
                    authManager.username = value;
                  }
              ),
              SizedBox(height: 20),
              ScopedModelDescendant<AuthManager>(
                builder: (context, widget, model) {
                  return DefaultButton(
                    isLoading: authManager.isLoading,
                    onPressed: onSavePressed,
                    child: RegularLabel(
                      title: Localization().getValue(Localization().nextContinue),
                      color: Colors.white,
                    ),
                  );
                }
              )
            ],
          ),
        )
    );
  }


}
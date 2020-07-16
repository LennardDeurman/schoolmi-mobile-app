import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:schoolmi/extensions/errorcodes.dart';
import 'package:schoolmi/managers/profile.dart';
import 'package:schoolmi/managers/file_upload.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/widgets/extensions/messages.dart';
import 'package:schoolmi/widgets/builders/editable_layout_state.dart';

class ProfilePage extends StatefulWidget {

  final ProfileManager profileManager;

  ProfilePage (this.profileManager);

  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }

}


class ProfilePageState extends EditableLayoutState<ProfilePage> {

  final TextEditingController usernameTextController = TextEditingController();
  final TextEditingController firstNameTextController = TextEditingController();
  final TextEditingController lastNameTextController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();
  final GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ProfileManager>(
        model: widget.profileManager,
        child: ScopedModel<FileUploadManager>(
            model: widget.profileManager.profileImageUploadManager,
            child: Scaffold(
                key: scaffoldKey,
                appBar: buildAppBar(context),
                floatingActionButton: buildFloatingActionButton(context),
                body: ScopedModelDescendant<ProfileManager>(
                    builder: (BuildContext context, Widget widget, ProfileManager manager) {
                      return buildBody(context);
                    }
                )
            )
        )
    );
  }

  @override
  Widget buildEditableBody(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildReadOnlyBody(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildFloatingActionButtonChild(BuildContext context) {
    return ScopedModelDescendant<ProfileManager>(
        builder: (BuildContext context, Widget widget, ProfileManager profileManager) {
          return ScopedModelDescendant<FileUploadManager>(
              builder: (BuildContext context, Widget widget, FileUploadManager uploadManager) {
                if (profileManager.isLoading || uploadManager.isLoading) {
                  return buildFabLoadingIndicator();
                } else {
                  return super.buildFloatingActionButtonChild(context);
                }
              }
          );
        }
    );
  }

  @override
  void onFabPressed() async {
    if (isEditing) {
      bool usernameValid = await widget.profileManager.executeAsync<bool>(widget.profileManager.isUsernameValid(usernameTextController.text));
      if (!usernameValid) {
        showSnackBar(message: Localization().getValue(Localization().errorUsernameExists), isError: true, scaffoldKey: scaffoldKey);
        return;
      }
    }
    super.onFabPressed();
  }

  @override
  void onClickFinishEditing() async {
    if (profileFormKey.currentState.validate()) {
      profileFormKey.currentState.save();
      widget.profileManager.saveUploadObjects().then((_) {
        isEditing = false;
      }).catchError((e) {
        if (e is Exception) {
          ErrorCode errorCode = ErrorCode.fromException(e);
          showSnackBar(scaffoldKey: scaffoldKey, message: errorCode.toString(), isError: true);
        }
      });
    }
  }

  @override
  void onClickStartEditing() {
    usernameTextController.text = widget.profileManager.uploadObject.username;
    lastNameTextController.text = widget.profileManager.uploadObject.lastName;
    firstNameTextController.text = widget.profileManager.uploadObject.firstName;
  }


  @override
  String get title {
    return Localization().getValue(Localization().myProfile);
  }

}
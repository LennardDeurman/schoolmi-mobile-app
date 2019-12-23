import 'dart:io';
import 'package:flutter/material.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/managers/profile.dart';
import 'package:schoolmi/managers/upload.dart';
import 'package:schoolmi/widgets/alerts/snackbar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:schoolmi/widgets/editable_layout_state.dart';
import 'package:schoolmi/widgets/cells/list_item.dart';
import 'package:schoolmi/widgets/circle_image.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/widgets/button.dart';
import 'package:schoolmi/widgets/parsing_result_bar.dart';
import 'package:schoolmi/widgets/file_selector.dart';
import 'package:schoolmi/pages/photo.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/extensions/validators.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/extensions/errorcodes.dart';

class ProfilePage extends StatefulWidget {

  final ProfileManager profileManager;

  ProfilePage (this.profileManager);

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }

}


class _ProfilePageState extends EditableLayoutState<ProfilePage> {

  TextEditingController _usernameTextController = TextEditingController();
  TextEditingController _firstNameTextController = TextEditingController();
  TextEditingController _lastNameTextController = TextEditingController();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
  GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(context),
      floatingActionButton: buildFloatingActionButton(context),
      body: ScopedModel<ProfileManager>(
          model: widget.profileManager, 
          child: ScopedModel<UploadManager>(
            model: widget.profileManager.profileImageUploadManager,
            child: buildBody(context),
          )
      ),
    );
  }


  Widget _buildProfileImage() {
    return GestureDetector(child: CircleImage(
        imageUrl: widget.profileManager.profileImageUploadManager.presentingUrl,
        firstLetter: widget.profileManager.profile.firstLetter,
        avatarColor: BrandColors.avatarColor(index: widget.profileManager.profile.avatarColorIndex)
    ), onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => PhotoViewPage(
            images: [widget.profileManager.profileImageUploadManager.presentingUrl],
            startAtIndex: 0,
          ),
        ),
      );
    });
  }

  @override
  Widget buildEditableBody(BuildContext context) {
    return Form(
      key: _profileFormKey,
      child: ListView(
        children: <Widget>[
          ListItem.withTextField(
              title: Localization().getValue(Localization().firstName),
              hintText: Localization().getValue(Localization().firstNameHint),
              controller: _firstNameTextController,
              validator: Validators.notEmptyValidator,
              onSaved: (String value) {
                widget.profileManager.uploadObject.firstName = value;
              }
          ),
          ListItem.withTextField(
              title: Localization().getValue(Localization().lastName),
              hintText: Localization().getValue(Localization().lastNameHint),
              controller: _lastNameTextController,
              validator: Validators.notEmptyValidator,
              onSaved: (String value) {
                widget.profileManager.uploadObject.lastName = value;
              }
          ),
          ListItem.withTextField(
              title: Localization().getValue(Localization().username),
              hintText: Localization().getValue(Localization().usernameHint),
              controller: _usernameTextController,
              validator: Validators.usernameValidator,
              onSaved: (String value) {
                widget.profileManager.uploadObject.username = value;
              }
          ),
          ListItem(
              trailing: DefaultButton(
                child: RegularLabel(title: Localization().getValue(Localization().changeProfilePicture)),
                onPressed: () {

                  FileSelector fileSelector = FileSelector(onFilesSelected: (List<File> files) {
                    widget.profileManager.profileImageUploadManager.upload(files.first);
                  }, context: context);
                  fileSelector.openFilePicker();

                },
              ),
              leading: ScopedModelDescendant<UploadManager>(builder: (BuildContext context, Widget widget, UploadManager manager) {
                return _buildProfileImage();
              }),
              contentPadding: EdgeInsets.all(20)
          ),

        ],
      ),
    );
  }

  @override
  Widget buildReadOnlyBody(BuildContext context) {
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: () async {
        await _refreshKey.currentState.show();
        await UserService().refreshData(forceRefresh: true);
      },
      child: ListView(
        children: <Widget>[
          ParsingResultBar(UserService().loginResult.profileResult, isLoading: UserService().profileParser.isLoading || UserService().myChannelsParser.isLoading),
          ListItem(
            title: TitleLabel(
              title: widget.profileManager.profile.fullName,
            ),
            leading: ScopedModelDescendant<UploadManager>(builder: (BuildContext context, Widget widget, UploadManager manager) {
              return _buildProfileImage();
            }),
            subtitle: RegularLabel(
              title: widget.profileManager.profile.username,
            ),
            contentPadding: EdgeInsets.all(20),
          ),
          ListItem(
              title: TitleLabel(
                title: Localization().getValue(Localization().email),
              ),
              subtitle: RegularLabel(
                title: widget.profileManager.profile.email,
              )
          ),
          ListItem(
              title: TitleLabel(
                title: Localization().getValue(Localization().score),
              ),
              subtitle: RegularLabel(
                title: widget.profileManager.profile.score.toString(),
              )
          ),
          ListItem(
              trailing: Icon(Icons.exit_to_app),
              title: RegularLabel(
                title:  Localization().getValue(Localization().logout),
              ),
              onPressed: () async {
                await widget.profileManager.logout();
              }
          )
        ],
      ),
    );
  }

  @override
  Widget buildFloatingActionButtonChild(BuildContext context) {
    return ScopedModelDescendant<ProfileManager>(
      builder: (BuildContext context, Widget widget, ProfileManager profileManager) {
        return ScopedModelDescendant<UploadManager>(
          builder: (BuildContext context, Widget widget, UploadManager uploadManager) {
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
  void onClickFinishEditing() {
    if (_profileFormKey.currentState.validate()) {
      _profileFormKey.currentState.save();
      widget.profileManager.saveUploadObjects().then((_) {
        isEditing = false;
      }).catchError((e) {
        if (e is Exception) {
          ErrorCode errorCode = ErrorCode.fromException(e);
          showSnackBar(scaffoldKey: _scaffoldKey, message: errorCode.toString(), isError: true);
        }
      });
    }
  }

  @override
  void onClickStartEditing() {
    _usernameTextController.text = widget.profileManager.profile.username;
    _lastNameTextController.text = widget.profileManager.profile.lastName;
    _firstNameTextController.text = widget.profileManager.profile.firstName;
  }


  @override
  String get title {
    return Localization().getValue(Localization().myProfile);
  }
}
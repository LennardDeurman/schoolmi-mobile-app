import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:schoolmi/managers/profile.dart';
import 'package:schoolmi/managers/file_upload.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/widgets/extensions/labels.dart';
import 'package:schoolmi/widgets/extensions/buttons.dart';
import 'package:schoolmi/widgets/lists/base/fetcher.dart';
import 'package:schoolmi/widgets/forms/listitem.dart';
import 'package:schoolmi/widgets/circle_image.dart';
import 'package:schoolmi/widgets/file_selector.dart';
import 'package:schoolmi/pages/photo.dart';
import 'package:schoolmi/extensions/validators.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/network/auth/user_service.dart';

abstract class ProfileForm extends StatelessWidget {
  
  final ProfileManager profileManager;
  final GlobalKey<RefreshIndicatorState> refreshKey;
  
  ProfileForm (this.profileManager, this.refreshKey);

  Widget profileImage(BuildContext context) {
    return GestureDetector(child: CircleImage(
        imageUrl: profileManager.profileImageUploadManager.presentingUrl,
        firstLetter: profileManager.uploadObject.firstLetter,
        avatarColor: BrandColors.avatarColor(index: profileManager.uploadObject.colorIndex)
    ), onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => PhotoViewPage(
            images: [profileManager.profileImageUploadManager.presentingUrl],
            startAtIndex: 0,
          ),
        ),
      );
    });
  }


  
}

class StaticProfileInfo extends ProfileForm {

  StaticProfileInfo (ProfileManager profileManager, GlobalKey<RefreshIndicatorState> refreshKey) : super(profileManager, refreshKey);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: () async {
        await profileManager.refresh();
      },
      child: ListView(
        children: <Widget>[
          FetchResultBar(ListState.static(fetchResult: UserService().userResult.myProfileResult, isLoading: profileManager.isLoading)),
          ListItem(
            title: TitleLabel(
              title: profileManager.uploadObject.fullName,
            ),
            leading: ScopedModelDescendant<FileUploadManager>(builder: (BuildContext context, Widget widget, FileUploadManager manager) {
              return profileImage(context);
            }),
            subtitle: RegularLabel(
              title: profileManager.uploadObject.username,
            ),
            contentPadding: EdgeInsets.all(20),
          ),
          ListItem(
              title: TitleLabel(
                title: Localization().getValue(Localization().email),
              ),
              subtitle: RegularLabel(
                title: profileManager.uploadObject.email,
              )
          ),
          ListItem(
              title: TitleLabel(
                title: Localization().getValue(Localization().score),
              ),
              subtitle: RegularLabel(
                title: profileManager.uploadObject.score.toString(),
              )
          ),
          ListItem(
              trailing: Icon(Icons.exit_to_app),
              title: RegularLabel(
                title:  Localization().getValue(Localization().logout),
              ),
              onPressed: () async {
                UserService().logout().then((_) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                });
              }
          )
        ],
      ),
    );
  }

}

class EditableProfileForm extends ProfileForm {

  final GlobalKey<FormState> profileFormKey;
  final TextEditingController firstNameTextController;
  final TextEditingController lastNameTextController;
  final TextEditingController usernameTextController;

  EditableProfileForm (ProfileManager profileManager, GlobalKey<RefreshIndicatorState> refreshKey,
  {
    this.profileFormKey,
    this.firstNameTextController,
    this.lastNameTextController,
    this.usernameTextController
  }) : super(profileManager, refreshKey);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: profileFormKey,
      child: ListView(
        children: <Widget>[
          ListItem.withTextField(
              title: Localization().getValue(Localization().firstName),
              hintText: Localization().getValue(Localization().firstNameHint),
              controller: firstNameTextController,
              validator: Validators.notEmptyValidator,
              onSaved: (String value) {
                profileManager.uploadObject.firstName = value;
              }
          ),
          ListItem.withTextField(
              title: Localization().getValue(Localization().lastName),
              hintText: Localization().getValue(Localization().lastNameHint),
              controller: lastNameTextController,
              validator: Validators.notEmptyValidator,
              onSaved: (String value) {
                profileManager.uploadObject.lastName = value;
              }
          ),
          ListItem.withTextField(
              title: Localization().getValue(Localization().username),
              hintText: Localization().getValue(Localization().usernameHint),
              controller: usernameTextController,
              validator: Validators.usernameValidator,
              onSaved: (String value) {
                profileManager.uploadObject.username = value;
              }
          ),
          ListItem(
              trailing: DefaultButton(
                child: RegularLabel(color: Colors.white, title: Localization().getValue(Localization().changeProfilePicture)),
                onPressed: () {

                  FileSelector fileSelector = FileSelector(onFilesSelected: (List<File> files) {
                    profileManager.profileImageUploadManager.upload(file: files.first);
                  }, context: context);
                  fileSelector.openFilePicker();

                },
              ),
              leading: ScopedModelDescendant<FileUploadManager>(builder: (BuildContext context, Widget widget, FileUploadManager manager) {
                return profileImage(context);
              }),
              contentPadding: EdgeInsets.all(20)
          ),

        ],
      ),
    );
  }

}
import 'package:flutter/material.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/widgets/editable_layout_state.dart';
import 'package:schoolmi/widgets/cells/list_item.dart';
import 'package:schoolmi/widgets/circle_image.dart';
import 'package:schoolmi/widgets/labels/regular.dart';
import 'package:schoolmi/widgets/labels/title.dart';
import 'package:schoolmi/widgets/button.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/extensions/validators.dart';

class ProfilePage extends StatefulWidget {

  final HomeManager homeManager;

  ProfilePage (this.homeManager);

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(context),
      floatingActionButton: buildFloatingActionButton(context),
      body: buildBody(context),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(child: CircleImage(
        imageUrl: widget.homeManager.profileManager.profileImageUploadManager.presentingUrl,
        firstLetter: widget.homeManager.profileManager.profile.firstLetter,
        avatarColor: BrandColors.avatarColor(index: widget.homeManager.profileManager.profile.avatarColorIndex)
    ), onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => PhotoViewPage(
            images: [widget.homeManager.profileManager.profileImageUploadManager.presentingUrl],
            startAtIndex: 0,
          ),
        ),
      );
    });
  }

  @override
  Widget buildEditableBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListItem.withTextField(
          title: Localization().getValue(Localization().firstName),
          hintText: Localization().getValue(Localization().firstNameHint),
          controller: _firstNameTextController,
          validator: Validators.notEmptyValidator,
          onSaved: (String value) {
            widget.homeManager.profileManager.uploadObject.firstName = value;
          }
        ),
        ListItem.withTextField(
            title: Localization().getValue(Localization().lastName),
            hintText: Localization().getValue(Localization().lastNameHint),
            controller: _lastNameTextController,
            validator: Validators.notEmptyValidator,
            onSaved: (String value) {
              widget.homeManager.profileManager.uploadObject.lastName = value;
            }
        ),
        ListItem.withTextField(
            title: Localization().getValue(Localization().username),
            hintText: Localization().getValue(Localization().usernameHint),
            controller: _usernameTextController,
            validator: Validators.usernameValidator,
            onSaved: (String value) {
              widget.homeManager.profileManager.uploadObject.username = value;
            }
        ),
        ListItem(
          trailing: DefaultButton(
            child: RegularLabel(title: Localization().getValue(Localization().changeProfilePicture)),
            onPressed: () {

              FileSelector fileSelector = FileSelector(onFilesSelected: (List<File> files) {
                widget.homeManager.profileManager.profileImageUploadManager.upload(files.first);
              }, context: context);
              fileSelector.openFilePicker();

            },
          ),
          leading: _buildProfileImage(),
          contentPadding: EdgeInsets.all(20)
        ),

      ],
    );
  }

  @override
  Widget buildReadOnlyBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListItem(
          title: TitleLabel(
            title: widget.homeManager.profileManager.profile.fullName,
          ),
          leading: _buildProfileImage(),
          subtitle: RegularLabel(
            title: widget.homeManager.profileManager.profile.username,
          ),
          contentPadding: EdgeInsets.all(20),
        ),
        ListItem(
          title: TitleLabel(
            title: Localization().getValue(Localization().email),
          ),
          subtitle: RegularLabel(
            title: widget.homeManager.profileManager.profile.email,
          )
        ),
        ListItem(
            title: TitleLabel(
              title: Localization().getValue(Localization().score),
            ),
            subtitle: RegularLabel(
              title: widget.homeManager.profileManager.profile.score.toString(),
            )
        ),
        ListItem(
          trailing: Icon(Icons.exit_to_app),
          title: RegularLabel(
            title:  Localization().getValue(Localization().logout),
          ),
          onPressed: () async {
            await widget.homeManager.profileManager.logout();
          }
        )
      ],
    );
  }

  @override
  void onClickFinishEditing() {
    if (_profileFormKey.currentState.validate()) {
      _profileFormKey.currentState.save();

      widget.homeManager.profileManager.save().catchError((e) {
        if (e is Exception) {
          ErrorCode errorCode = ErrorCode.fromException(e);
          showSnackBar(scaffoldKey: _scaffoldKey, message: errorCode.toString(), isError: true);
        }
      });
    }
  }

  @override
  void onClickStartEditing() {
    _usernameTextController.text = widget.homeManager.profileManager.profile.username;
    _lastNameTextController.text = widget.homeManager.profileManager.profile.lastName;
    _firstNameTextController.text = widget.homeManager.profileManager.profile.firstName;
  }
}
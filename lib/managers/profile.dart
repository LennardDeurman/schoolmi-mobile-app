import 'dart:async';

import 'package:schoolmi/managers/child_manager.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/managers/upload.dart';
import 'package:schoolmi/network/parsing_result.dart';
import 'package:schoolmi/network/api.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/models/data/profile.dart';
import 'package:schoolmi/managers/upload_interface.dart';

class ProfileManager extends ChildManager with UploadInterface<Profile> {

  final HomeManager homeManager;

  final UploadManager profileImageUploadManager = new UploadManager();

  ProfileManager (this.homeManager) : super(homeManager) {
    parser = UserService().profileParser;
  }

  Profile get profile {
    return UserService().loginResult.profile;
  }

  @override
  Future<List<Profile>> saveUploadObjects() {
    Future uploadFuture = performUpload(parser);
    uploadFuture.then((objects) {
      UserService().loginResult.profileResult = ParsingResult(objects); //Reset the profileResult as parser upload
    });
    Future<List<Profile>> profileFuture = wrapUpload(uploadFuture);
    return executeAsync<List<Profile>>(profileFuture);
  }

  @override
  void loadData() {
    profileImageUploadManager.dataUrl = UserService().loginResult.profile.avatarImageUrl;
    uploadObject = new Profile(UserService().loginResult.profile.dictionary);
  }

  Future refresh() async {
    executeAsync(homeManager.executeAsync(homeManager.downloadProfile())); //Inside the profile manager the loading callback must ork, while also the homemanager needs to be updated
  }

  Future<bool> isUsernameValid(String username) async {
    Completer<bool> completer = new Completer();
    Api.usernameValid(username).then((valid) {
      completer.complete(valid);
    }).catchError((e) {
      completer.complete(false);
    });
    return completer.future;
  }
}
import 'package:schoolmi/managers/child_manager.dart';
import 'package:schoolmi/managers/home.dart';
import 'package:schoolmi/managers/upload.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/models/data/profile.dart';

abstract class UploadInterface<T> {

  T uploadObject;

  Future<T> save();

}

class ProfileManager extends ChildManager with UploadInterface<Profile> {

  final HomeManager homeManager;

  final UploadManager profileImageUploadManager = new UploadManager();

  ProfileManager (this.homeManager) : super(homeManager);

  Profile get profile {
    return UserService().loginResult.profile;
  }

  Future logout() async {
    await UserService().logout();
  }

  @override
  Future<Profile> save() async {
    return executeAsync(future);
  }


  @override
  void loadData() {
    profileImageUploadManager.dataUrl = UserService().loginResult.profile.avatarImageUrl;
    uploadObject = new Profile(UserService().loginResult.profile.dictionary);
  }
}
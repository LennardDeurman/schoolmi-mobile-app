import 'package:schoolmi/managers/abstract.dart';
import 'package:schoolmi/managers/file_upload.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/network/models/profile.dart';
import 'package:schoolmi/network/requests/username.dart';

class ProfileManager extends BaseManager with UploadInterface<Profile> {

  FileUploadManager profileImageUploadManager;

  ProfileManager () {
    profileImageUploadManager = FileUploadManager(UserService().userResult.myProfile.imageUrl);
    uploadObject = Profile(UserService().userResult.myProfile.toDictionary());
  }

  Future logout() async {
    await UserService().logout();
  }

  @override
  Future<Profile> saveUploadObject() {
    return executeAsync(
        UserService().userResult.saveMyProfile(
            uploadObject
        )
    );
  }

  Future<bool> isUsernameValid(String username) async {
    return UsernameRequest().usernameValid(username);
  }

  Future<Profile> refresh() {
    return executeAsync(
      UserService().userResult.refreshMyProfile()
    );
  }
}
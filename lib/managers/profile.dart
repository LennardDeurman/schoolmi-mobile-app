
import 'package:schoolmi/managers/abstract.dart';
import 'package:schoolmi/managers/file_upload.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/network/models/profile.dart';

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

}
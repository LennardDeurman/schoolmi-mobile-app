import 'package:firebase_auth/firebase_auth.dart';
import 'package:schoolmi/managers/base_manager.dart';
import 'package:schoolmi/models/data/profile.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/extensions/exceptions.dart';

enum AuthActionState {
  login,
  register,
  forgotPassword,
  verifyEmail,
  passwordResetSent,
  loggedIn
}

class AuthManager extends BaseManager {

  String email;
  String password;
  String firstName;
  String lastName;
  String username;

  AuthActionState _authActionState = AuthActionState.login;

  AuthManager () : super();


  AuthActionState get authActionState {
    return _authActionState;
  }

  set authActionState (AuthActionState value) {
    _authActionState = value;
    notifyListeners();
  }

  void saveCachedProfileInfo() {
    Profile.setCachedInfo(email: email, firstName: firstName, lastName: lastName, username: username);
  }

  Future initialize() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser != null) {
      if (firebaseUser.isEmailVerified) {
        authActionState = AuthActionState.verifyEmail;
      }
    }
  }

  Future login() async {
    saveCachedProfileInfo();
    await UserService().login(email: email, password: password);
  }

  Future register() async {
    saveCachedProfileInfo();
    await UserService().register(email: email, password: password);
  }

  Future sendPasswordForgotEmail() async {
    await UserService().sendPasswordForgotEmail(email: email);
    authActionState = AuthActionState.passwordResetSent;
  }

  Future refreshLoginState() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser != null) {
      if (firebaseUser.isEmailVerified) {
        UserService().refreshStreamState(firebaseUser);
        return;
      } else {
        throw new LoginException(LoginError.emailNotVerified, "email was still not verified");
      }
    }
    throw new LoginException(LoginError.noUserActive, "no user active anymore, login again");
  }

}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:schoolmi/managers/abstract.dart';
import 'package:schoolmi/network/models/profile.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:schoolmi/extensions/exceptions.dart';
import 'package:schoolmi/network/requests/username.dart';

enum AuthActionState {
  login,
  register,
  forgotPassword,
  verifyEmail,
  passwordResetSent,
  loggedIn
}

class InvalidUsernameError implements Exception {

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

  Future saveUserInfo() async {
    bool isValid = await UsernameRequest().usernameValid(username);
    if (!isValid) {
      throw InvalidUsernameError();
    }
    saveCachedProfileInfo();

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
    bool isValid = await UsernameRequest().usernameValid(username);
    if (!isValid) {
      throw InvalidUsernameError();
    }
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
        UserService().refreshStream(firebaseUser);
        return;
      } else {
        throw new LoginException(LoginError.emailNotVerified, "email was still not verified");
      }
    }
    throw new LoginException(LoginError.noUserActive, "no user active anymore, login again");
  }

}

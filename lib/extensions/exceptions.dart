class InvalidOperationException implements Exception {


  final String message;

  InvalidOperationException (this.message);

}

class LocalizationException implements Exception {


  final String message;

  LocalizationException (this.message);

}

enum LoginError {
  emailNotVerified,
  noUserActive
}

class LoginException extends InvalidOperationException {

  final LoginError loginError;

  LoginException (this.loginError, String message) : super(message);

}
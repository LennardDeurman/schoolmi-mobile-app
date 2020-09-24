import 'package:flutter/services.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/managers/auth.dart';
class ErrorCode {

  String firebaseCode;

  static const String errorWrongPassword = "ERROR_WRONG_PASSWORD";
  static const String errorEmailAlreadyInUse = "ERROR_EMAIL_ALREADY_IN_USE";
  static const String errorUserNotFound = "ERROR_USER_NOT_FOUND";
  static const String errorUserNameExists = "ERROR_USERNAME_EXISTS";

  ErrorCode.fromException(Exception e) {
    if (e is PlatformException) {
      PlatformException platformException = e;
      this.firebaseCode = platformException.code;
    } else if (e is InvalidUsernameError) {
      this.firebaseCode = errorUserNameExists;
    }
  }

  ErrorCode (this.firebaseCode);

  String toString() {
    if (this.firebaseCode != null) {
       switch (this.firebaseCode) {
         case ErrorCode.errorWrongPassword:
            return Localization().getValue(Localization().errorWithCredentials);
         case ErrorCode.errorEmailAlreadyInUse:
           return Localization().getValue(Localization().errorEmailAlreadyInUse);
         case ErrorCode.errorUserNotFound:
           return Localization().getValue(Localization().errorAccountNotFound);
         case ErrorCode.errorUserNameExists:
           return Localization().getValue(Localization().errorUsernameExists);
         default:
           break;
       }
    }
    return Localization().getValue(Localization().errorUnexpected);
  }

}
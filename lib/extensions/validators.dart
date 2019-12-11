import 'package:schoolmi/localization/localization.dart';

class Validators {

  static String emailValidator(String value) {
    value = value.trim();
    if (value.isEmpty ||
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
      return Localization().getValue(Localization().emailError);
    }
    return null;
  }

  static String passwordValidator(String value) {
    if (value.length < 6) {
      return Localization().getValue(Localization().passwordTooShort);
    }
    return null;
  }

  static String usernameValidator(String value) {
    if (value.length < 6) {
      return Localization().getValue(Localization().usernameTooShort);
    }
    return null;
  }

  static String notEmptyValidator(String value) {
    if (value.isEmpty) return Localization().getValue(Localization().obligatoryField);
    return null;
  }

}
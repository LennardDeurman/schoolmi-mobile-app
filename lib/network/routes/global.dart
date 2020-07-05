import 'package:schoolmi/network/routes/extensions.dart';
class GlobalRoute with ObjectWithNotificationRoute {

  String get upload {
    return "upload";
  }

  String get profile {
    return "profile";
  }

  String get devices {
    return "devices";
  }

  String get usernameCheck {
    return "username";
  }

  String get notificationSettings {
    return "notifications/settings";
  }

  String get myChannels {
    return "channels";
  }

  String get publicChannels {
    return "channels/public";
  }

}
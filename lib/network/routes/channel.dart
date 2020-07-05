import 'package:schoolmi/network/routes/extensions.dart';
class ChannelRoute with ObjectWithNotificationRoute {

  final int channelId;

  ChannelRoute ({
    this.channelId
  });

  String get baseRoute {
    return "channels/$channelId";
  }

  String get members {
    return "$baseRoute/members";
  }

  String get tags {
    return "$baseRoute/tags";
  }

  String get roles {
    return "$baseRoute/roles";
  }

  String get mentions {
    return "$baseRoute/mentions";
  }

  String get join {
    return "$baseRoute/join";
  }

  String get leave {
    return "$baseRoute/leave";
  }

  String get joinCode {
    return "$baseRoute/code";
  }

  String get notificationSettings {
    return "$baseRoute/notifications/settings";
  }

  String get questions {
    return "$baseRoute/questions";
  }

}
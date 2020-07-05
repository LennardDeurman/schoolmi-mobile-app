
abstract class ObjectWithNotificationRoute {

  String get notificationSettings;

}

class ChannelChildObjectRoute {

  final int channelId;

  ChannelChildObjectRoute ({
    this.channelId
  });

  String get baseRoute {
    return "channels/$channelId";
  }

  String get comments {
    return "$baseRoute/comments";
  }

  String get versions {
    return "$baseRoute/versions";
  }

  String get votes {
    return "$baseRoute/vote";
  }

  String get flags {
    return "$baseRoute/flags";
  }

  String get followSettings {
    return "$baseRoute/follow_settings";
  }

  String get viewers {
    return "$baseRoute/viewers";
  }

}
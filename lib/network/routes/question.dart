import 'package:schoolmi/network/routes/extensions.dart';
class QuestionRoute extends ChannelChildObjectRoute {

  final int questionId;

  QuestionRoute ({
    this.questionId,
    channelId
  }) : super(channelId: channelId);

  String get baseRoute {
    return "channels/$channelId/questions/$questionId";
  }

  String get answers {
    return "$baseRoute/answers";
  }

  String get questionDetails {
    return "$baseRoute";
  }

  String get duplicates {
    return "$baseRoute/duplicates";
  }

  String get duplicatesFlaggedByMe {
    return "$baseRoute/duplicates/flagged_by_me";
  }


}
import 'package:schoolmi/network/routes/extensions.dart';
class AnswerRoute extends ChannelChildObjectRoute {

  final int answerId;
  final int questionId;

  AnswerRoute ({
    this.questionId,
    this.answerId
  });

  String get baseRoute {
    return "channels/$channelId/questions/$questionId/answers/$answerId";
  }

}
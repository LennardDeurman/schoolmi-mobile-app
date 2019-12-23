
import 'package:schoolmi/models/data/question.dart';
import 'package:schoolmi/network/channel_base_parser.dart';
import 'package:schoolmi/network/query_info.dart';
import 'package:schoolmi/network/urls.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/models/base_object.dart';


class QuestionsParser extends ChannelBaseNetworkParser with ParserWithQueryInfo {

  int questionId;

  QuestionsParser (Channel channel, { this.questionId } ) : super(channel);

  @override
  String get downloadUrl {
    if (questionId != null) {
      return Urls.questionDetails(channelId: channel.id, questionId: questionId);
    }
    return Urls.questions(channelId: channel.id, queryInfo: this.queryInfo);
  }

  @override
  String get uploadUrl {
    return Urls.questions(channelId: channel.id);
  }

  @override
  BaseObject toObject(Map dictionary) {
    return Question(dictionary);
  }
}
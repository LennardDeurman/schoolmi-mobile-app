import 'package:schoolmi/network/channel_base_parser.dart';
import 'package:schoolmi/network/urls.dart';
import 'package:schoolmi/models/data/channel.dart';

class DuplicatesParser extends ChannelBaseNetworkParser {

  int questionId;

  DuplicatesParser (Channel channel, this.questionId) : super(channel);

  @override
  String get downloadUrl {
    return Urls.duplicatedQuestions(channelId: channel.id, questionId: questionId);
  }

  @override
  String get uploadUrl {
    throw new UnimplementedError("Use dedicated duplicates update call instead");
  }


}


import 'package:schoolmi/network/channel_base_parser.dart';
import 'package:schoolmi/network/query_info.dart';
import 'package:flutter/foundation.dart';
import 'package:schoolmi/network/urls.dart';
import 'package:schoolmi/models/data/channel.dart';

class AnswerParser extends ChannelBaseNetworkParser with ParserWithQueryInfo {

  int questionId;


  AnswerParser (Channel channel, { @required this.questionId} ) : super(channel);

  @override
  String get downloadUrl {
    return  Urls.answers(channelId: this.channel.id, questionId: this.questionId, queryInfo: queryInfo);
  }

  @override
  String get uploadUrl {
    return Urls.answers(channelId: this.channel.id);
  }


}
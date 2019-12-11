import 'package:schoolmi/network/query_info.dart';
import 'package:schoolmi/network/channel_base_parser.dart';
import 'package:schoolmi/network/urls.dart';
import 'package:flutter/foundation.dart';
import 'package:schoolmi/models/data/channel.dart';

class CommentsParser extends ChannelBaseNetworkParser with ParserWithQueryInfo {

  int questionId;
  int answerId;

  CommentsParser (Channel channel, { @required this.questionId, this.answerId}) : super(channel);

  @override
  String get downloadUrl {
    return Urls.comments(channelId: channel.id, questionId: questionId, answerId: answerId, queryInfo: queryInfo);
  }

  @override
  String get uploadUrl {
    return Urls.comments(channelId: channel.id);
  }

}
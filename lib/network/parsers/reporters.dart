import 'package:flutter/foundation.dart';
import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/models/data/profile.dart';
import 'package:schoolmi/network/channel_base_parser.dart';
import 'package:schoolmi/network/urls.dart';

class ReportersParser extends ChannelBaseNetworkParser {

  final int questionId;
  final int answerId;
  final int commentId;

  ReportersParser (Channel channel, {@required this.questionId, this.commentId, this.answerId}) : super(channel);

  @override
  String get downloadUrl {
    return Urls.reporters(channelId: channel.id, questionId: this.questionId, commentId: this.commentId, answerId: this.answerId);
  }

  @override
  String get uploadUrl {
    throw new UnimplementedError("Error cannot add reports. Use dedicated flag call");
  }

  @override
  BaseObject toObject(Map dictionary) {
    return Profile(dictionary);
  }
}
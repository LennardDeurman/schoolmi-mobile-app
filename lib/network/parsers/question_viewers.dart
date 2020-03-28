import 'package:flutter/foundation.dart';
import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/models/data/channel.dart';
import 'package:schoolmi/models/data/question_viewer.dart';
import 'package:schoolmi/network/channel_base_parser.dart';
import 'package:schoolmi/network/urls.dart';

class QuestionViewersParser extends ChannelBaseNetworkParser {

  final int questionId;

  QuestionViewersParser (Channel channel, { @required this.questionId }) : super(channel);

  @override
  String get downloadUrl {
    return Urls.questionViewers(channelId: channel.id, questionId: this.questionId);
  }

  @override
  String get uploadUrl {
    throw new UnimplementedError("Error! Cannot add viewers from app");
  }

  @override
  BaseObject toObject(Map dictionary) {
    return QuestionViewer(dictionary);
  }
}
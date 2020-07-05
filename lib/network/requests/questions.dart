import 'package:schoolmi/network/requests/abstract/rest.dart';
import 'package:schoolmi/network/models/question.dart';
import 'package:schoolmi/network/routes/channel.dart';
import 'package:schoolmi/network/download_info.dart';
import 'package:flutter/foundation.dart';

class QuestionsRequest extends RestRequest<Question> {


  QuestionsRequest ({ @required int channelId }) : super(
      ChannelRoute(channelId: channelId).questions,
      objectCreator: (Map<String, dynamic> map) {
        return Question(map);
      }
  );

  @override
  Future delete() {
    throw UnimplementedError();
  }

  @override
  Future<Question> getSingle({DownloadStatusInfo downloadStatusListener}) {
    throw UnimplementedError();
  }

  @override
  Future<List<Question>> postAll(List<Question> objectsToPost, {singleObjectFormat = false}) {
    throw UnimplementedError();
  }
}
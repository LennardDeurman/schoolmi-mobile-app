import 'package:schoolmi/network/requests/abstract/rest.dart';
import 'package:schoolmi/network/models/answer.dart';
import 'package:schoolmi/network/routes/question.dart';
import 'package:schoolmi/network/download_info.dart';
import 'package:flutter/foundation.dart';

class AnswersRequest extends RestRequest<Answer> {

  AnswersRequest ({ @required int channelId, @required int questionId }) : super(
      QuestionRoute(channelId: channelId, questionId: questionId).answers,
      objectCreator: (Map<String, dynamic> map) {
        return Answer(map);
      }
  );

  @override
  Future delete() {
    throw UnimplementedError();
  }

  @override
  Future<Answer> getSingle({DownloadStatusInfo downloadStatusListener}) {
    throw UnimplementedError();
  }

  @override
  Future<List<Answer>> postAll(List<Answer> objectsToPost, {singleObjectFormat = false}) {
    throw UnimplementedError();
  }

}

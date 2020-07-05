import 'package:schoolmi/network/requests/abstract/rest.dart';
import 'package:schoolmi/network/models/question.dart';
import 'package:schoolmi/network/routes/question.dart';
import 'package:schoolmi/network/download_info.dart';
import 'package:schoolmi/network/params/abstract/base.dart';
import 'package:flutter/foundation.dart';

class QuestionDetailsRequest extends RestRequest<Question> {


  QuestionDetailsRequest ({ @required int channelId, @required int questionId }) : super(
      QuestionRoute(channelId: channelId, questionId: questionId).questionDetails,
      objectCreator: (Map<String, dynamic> map) {
        return Question(map);
      }
  );

  @override
  Future delete() {
    throw UnimplementedError();
  }

  @override
  Future<List<Question>> getAll({RequestParams params, DownloadStatusInfo downloadStatusListener}) {
    throw UnimplementedError();
  }

  @override
  Future<List<Question>> postAll(List<Question> objectsToPost, {singleObjectFormat = false}) {
    throw UnimplementedError();
  }

  @override
  Future<Question> postSingle(Question objectToPost, {singleObjectFormat = true}) {
    throw UnimplementedError();
  }

}
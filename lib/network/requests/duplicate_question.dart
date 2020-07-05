
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:schoolmi/network/models/question.dart';
import 'package:schoolmi/network/routes/question.dart';
import 'package:schoolmi/network/requests/abstract/base.dart';
import 'package:schoolmi/network/params/abstract/base.dart';
import 'package:schoolmi/network/json_object_formatter.dart';
import 'package:schoolmi/network/download_info.dart';
import 'package:schoolmi/network/urls.dart';
import 'package:schoolmi/network/keys.dart';

class DuplicateQuestionRequest extends Request {

  QuestionRoute route;

  DuplicateQuestionRequest ( { @required int questionId, @required int channelId } ) {
    route = QuestionRoute(questionId: questionId, channelId: channelId);
  }

  Future delete() {
    return http.delete(route.duplicates);
  }

  Future update(List<int> duplicateQuestionIds) {
    Completer completer = Completer();
    Map<String, dynamic> body = {
      Keys().duplicateOfQuestionIds: duplicateQuestionIds
    };
    executeJsonRequest(route.duplicates, completer, (response) {
      completer.complete();
    }, postDictionary: body);
    return completer.future;
  }

  Future<List<int>> myFlags() {
    Completer<List<int>> completer = Completer();
    executeJsonRequest(route.duplicatesFlaggedByMe, completer, (response) {
      var ids = jsonObjectResponse(response);
      completer.complete(ids);
    });
    return completer.future;
  }

  Future<List<DuplicateQuestion>> getAll({ RequestParams params, DownloadStatusInfo downloadStatusListener }) {
    Completer<List<DuplicateQuestion>> completer = new Completer();
    downloadStatusListener.downloadDidStart();
    String url = Urls.urlForPath(
        path: route.duplicates,
        params: params
    );
    executeJsonRequest(url, completer, (http.Response response) {
      var jsonResponse = jsonObjectResponse(response);
      var items = JsonObjectFormatter<DuplicateQuestion>((Map<String, dynamic> dictionary) {
        return DuplicateQuestion(dictionary);
      }).parseObjects(jsonResponse);
      completer.complete(items);
    });

    completer.future.then((_) {
      downloadStatusListener.downloadDidSucceed();
    });

    completer.future.catchError((e) {
      downloadStatusListener.downloadDidFail(e);
    });

    return completer.future;
  }





}
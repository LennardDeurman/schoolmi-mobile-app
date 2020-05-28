import 'dart:async';

import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/data/question.dart';
import 'package:schoolmi/network/api.dart';
import 'package:schoolmi/network/urls.dart';
import 'package:http/http.dart' as http;

class DuplicatesApi {

  final Question question;

  DuplicatesApi (this.question);

  Map<String, dynamic> makeDuplicateMap({ int duplicateOfQuestionId, bool isDeleted, String posterUid }) {
    return {
      Keys().questionId: question.id,
      Keys().isDuplicateOf: duplicateOfQuestionId,
      Keys().deleted: isDeleted,
      Keys().uid: posterUid
    };
  }

  Future updateDuplicateQuestions ( { List<Map<String, dynamic>> duplicatesMapList} ) {
    Map<String, dynamic> map = {
      Keys().duplicates: duplicatesMapList
    };
    Completer completer = new Completer();
    String url = Urls.duplicatedQuestions(channelId: this.question.channelId, questionId: this.question.id);
    Api.executeJsonRequest(url, completer, (http.Response response) {
      completer.complete();
    }, postDictionary: map);
    return completer.future;
  }


}
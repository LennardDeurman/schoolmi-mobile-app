import 'package:schoolmi/models/base_object.dart';
import 'package:schoolmi/network/urls.dart';
import 'package:schoolmi/constants/keys.dart';
import 'package:schoolmi/models/data/upload.dart';
import 'package:schoolmi/extensions/exceptions.dart';
import 'package:schoolmi/network/network_parser.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

enum HttpMethod {
  post,
  get
}

class Headers {
  static const String idToken = "X-Id-Token";
  static const String contentType = "Content-Type";
  static const String mediaTypeJson = "application/json";
}

class Api {

  static String dummyToken;

  static Future<String> getIdToken() async {
    if (dummyToken != null) {
      return dummyToken;
    }

    String firebaseToken = await (await FirebaseAuth.instance.currentUser()).getIdToken();
    return firebaseToken;
  }

  static void _executeJsonRequest(String url, Completer completer,
      Function(http.Response response) handleSuccessAction, { Map<String, dynamic> postDictionary, HttpMethod httpMethod } ) async {

    if (httpMethod == null) {
      httpMethod = postDictionary != null ? HttpMethod.post : HttpMethod.get;
    }

    Map<String, String> headers = {
      Headers.contentType: Headers.mediaTypeJson,
      Headers.idToken: await getIdToken(),
    };

    var action;
    if (httpMethod == HttpMethod.get) {
      action = http.get(url, headers: headers);
    } else if (httpMethod == HttpMethod.post) {
      action = http.post(url, headers: headers, body: postDictionary != null ? json.encode(postDictionary) : null);
    }

    action.then((http.Response response) {
      handleSuccessAction(response);
    }).catchError((e) {
      completer.completeError(e);
    });
  }

  static Future<BaseObject> downloadObject({@required NetworkParser parser}) {
    Completer<BaseObject> completer = new Completer();
    downloadObjects(parser: parser).then((List<BaseObject> baseObjects) {
      completer.complete(baseObjects.length > 0 ? baseObjects[0] : null);
    });
    return completer.future;
  }

  static Future<List<BaseObject>> downloadObjects({@required NetworkParser parser}) {
    Completer<List<BaseObject>> completer = new Completer();
    parser.downloadStatusInfo.downloadDidStart();

    _executeJsonRequest(parser.downloadUrl, completer, (http.Response response) {
      var baseObjects = parser.objectsFromResponse(response);
      completer.complete(baseObjects);
    });

    completer.future.then((_) {
      parser.downloadStatusInfo.downloadDidSucceed();
    });

    completer.future.catchError((e) {
      parser.downloadStatusInfo.downloadDidFail(e);
    });

    return completer.future;
  }

  static Future<List<BaseObject>> uploadObjects({@required NetworkParser parser, @required List<BaseObject> uploadObjects}) {
    Completer<List<BaseObject>> completer = new Completer();
    _executeJsonRequest(parser.uploadUrl, completer, (http.Response response) {
      completer.complete(parser.objectsFromPostResponse(uploadObjects, response));
    }, postDictionary: parser.toPostDictionary(uploadObjects));
    return completer.future;
  }

  static Future<BaseObject> uploadObject({@required NetworkParser parser, @required BaseObject uploadObject}) {
    Completer<BaseObject> completer = new Completer();
    Api.uploadObjects(parser: parser, uploadObjects: [uploadObject]).then((List<BaseObject> objects){
      completer.complete(objects.length > 0 ? objects[0] : null);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  static Future<void> joinChannel({@required int channelId}) {
    Completer completer = new Completer();
    _executeJsonRequest(Urls.joinChannel(channelId: channelId), completer, (http.Response response) {
      completer.complete();
    }, httpMethod: HttpMethod.post);
    return completer.future;
  }

  static Future<void> leaveChannel({@required int channelId}) {
    Completer completer = new Completer();
    _executeJsonRequest(Urls.leaveChannel(channelId: channelId), completer, (http.Response response) {
      final body = json.decode(response.body)[Keys.object];
      int statusCode = body[Keys.statusCode];
      if (statusCode == 1) {
        throw new InvalidOperationException("Status indicates you should first set a new admin");
      }
      completer.complete();
    }, httpMethod: HttpMethod.post);
    return completer.future;
  }

  static Future<bool> usernameValid(String username) {
    Completer<bool> completer = new Completer();
    _executeJsonRequest(Urls.usernameExists, completer, (http.Response response) {
      final body = json.decode(response.body)[Keys.object];
      bool valid = body[Keys.valid];
      completer.complete(valid);
    });
    return completer.future;
  }

  static Future<void> updateFlagStatus({ @required int questionId, int answerId = 0, int commentId = 0, bool flagged = true }) {
    Map<String, dynamic> dictionary = {
      Keys.questionId: questionId,
      Keys.answerId: answerId,
      Keys.commentId: commentId,
      Keys.deleted: !flagged
    };
    Completer<void> completer = new Completer();
    _executeJsonRequest(Urls.flagContent, completer, (http.Response response) {
      completer.complete();
    }, postDictionary: dictionary);

    return completer.future;
  }

  static Future<Upload> uploadFile({
    @required File file,
    bool includeMini = true,
    int size = 1024
  }) async { 
    Completer<Upload> completer = Completer();
    Map<String, String> headers = {
      Headers.idToken: await getIdToken(),
      Headers.contentType: Headers.mediaTypeJson
    };

    List<int> bytes = file.readAsBytesSync();
    String fileName = file.path.split("/").last;
    Uri url = Uri.parse(Urls.uploadFile(
        includeMini: includeMini,
        maxSize: size
    ));
    http.MultipartRequest multipartRequest = http.MultipartRequest(
        "post", url
    );
    multipartRequest.headers.addAll(headers);
    multipartRequest.files.add(http.MultipartFile.fromBytes(
      Keys.file,
      bytes,
      filename: fileName,
    ));
    multipartRequest.send().then((http.StreamedResponse response) async {
      http.Response httpResponse = await http.Response.fromStream(response);
      final body = json.decode(httpResponse.body)[Keys.object];
      completer.complete(Upload(body));
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

}
import 'package:schoolmi/network/query_info.dart';
import 'package:schoolmi/network/models/comment.dart';
import 'package:schoolmi/network/models/channel.dart';
import 'package:schoolmi/network/models/role.dart';
import 'package:schoolmi/network/models/member.dart';
import 'package:schoolmi/network/models/profile.dart';
import 'package:schoolmi/network/models/attachment.dart';
import 'package:schoolmi/network/models/question.dart';
import 'package:schoolmi/network/models/tag.dart';
import 'package:schoolmi/network/models/extensions/object_with_votes.dart';
import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/extensions/enum_utils.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/extensions/exceptions.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schoolmi/network/download_info.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:schoolmi/network/models/notification_settings.dart';


abstract class ObjectWithNotificationRoute {

    String get notificationSettings;

}

class GlobalRoute with ObjectWithNotificationRoute {

  String get upload {
    return "upload";
  }

  String get profile {
    return "profile";
  }

  String get devices {
    return "devices";
  }

  String get usernameCheck {
    return "username";
  }

  String get notificationSettings {
    return "notifications/settings";
  }

  String get myChannels {
    return "channels";
  }

  String get publicChannels {
    return "channels/public";
  }

}

class ChannelRoute with ObjectWithNotificationRoute {

  final int channelId;

  ChannelRoute ({
    this.channelId
  });

  String get baseRoute {
    return "channels/$channelId";
  }

  String get members {
    return "$baseRoute/members";
  }

  String get tags {
    return "$baseRoute/tags";
  }

  String get roles {
    return "$baseRoute/roles";
  }

  String get mentions {
    return "$baseRoute/mentions";
  }

  String get join {
    return "$baseRoute/join";
  }

  String get leave {
    return "$baseRoute/leave";
  }

  String get joinCode {
    return "$baseRoute/code";
  }

  String get notificationSettings {
    return "$baseRoute/notifications/settings";
  }

  String get questions {
    return "$baseRoute/questions";
  }

}

class ChannelChildObjectRoute {

  final int channelId;

  ChannelChildObjectRoute ({
    this.channelId
  });

  String get baseRoute {
    return "channels/$channelId";
  }

  String get comments {
    return "$baseRoute/comments";
  }

  String get versions {
    return "$baseRoute/versions";
  }

  String get votes {
    return "$baseRoute/vote";
  }

  String get flags {
    return "$baseRoute/flags";
  }

  String get followSettings {
    return "$baseRoute/follow_settings";
  }

  String get viewers {
    return "$baseRoute/viewers";
  }

}

class QuestionRoute extends ChannelRoute {

  final int questionId;

  QuestionRoute ({
    this.questionId,
    channelId
  }) : super(channelId: channelId);

  String get baseRoute {
    return "channels/$channelId/questions/$questionId";
  }

  String get answers {
    return "$baseRoute/answers";
  }

  String get questionDetails {
    return "$baseRoute";
  }

  String get duplicates {
    return "$baseRoute/duplicates";
  }

  String get duplicatesFlaggedByMe {
    return "$baseRoute/duplicates/flagged_by_me";
  }


}

class AnswerRoute extends ChannelRoute {

  final int answerId;
  final int questionId;

  AnswerRoute ({
    this.questionId,
    this.answerId
  });

  String get baseRoute {
    return "channels/$channelId/questions/$questionId/answers/$answerId";
  }

}

class CommentsRoute extends ChannelRoute {

  final int commentId;

  CommentsRoute ({
    this.commentId
  });

  String get baseRoute {
    return "channels/$channelId/comments/$commentId";
  }



}

enum ListOrder {
  updated,
  newest,
  points
}

class UploadRequestParams extends RequestParams {

  final int width;
  final int height;
  final String mode;
  final bool makeMiniImage;
  final File file;

  UploadRequestParams ({
    this.width,
    this.height,
    this.mode = "thumbnail",
    this.makeMiniImage = false,
    this.file
  });

  Map<String, String> get queryMap {
    return {
      Keys().mode: queryParam(mode),
      Keys().width: queryParam(width),
      Keys().height: queryParam(height),
      Keys().includeMini: queryParam(makeMiniImage)
    };
  }

}

enum QuestionsFilterMode {
  all,
  followed,
  newItems,
  updated,
  unanswered,
  flagged,
  deleted
}

class QuestionsRequestParams extends ListRequestParams {

  final QuestionsFilterMode filterMode;

  QuestionsRequestParams ({
    this.filterMode,
    search,
    offset = 0,
    limit = 50,
    orderType,
    firebaseUids,
    roleIds
  }) : super(
      search: search,
      offset: offset,
      limit: limit,
      orderType: orderType,
      firebaseUids: firebaseUids,
      roleIds: roleIds
  );

  Map<String, String> get queryMap {
    Map<String, String> queryMap = super.queryMap;
    queryMap[Keys().filterMode] = queryParam(EnumUtils.indexOf(filterMode, QuestionsFilterMode.values));
    return queryMap;
  }

}


class AnswersRequestParams extends ListRequestParams {

  final bool showDeletedAnswers;

  AnswersRequestParams ({
    this.showDeletedAnswers = false,
    search,
    offset = 0,
    limit = 50,
    orderType,
    firebaseUids,
    roleIds
  }) : super(
    search: search,
    offset: offset,
    limit: limit,
    orderType: orderType,
    firebaseUids: firebaseUids,
    roleIds: roleIds
  );

  Map<String, String> get queryMap {
    Map<String, String> queryMap = super.queryMap;
    queryMap[Keys().showDeletedAnswers] = queryParam(showDeletedAnswers);
    return queryMap;
  }



}

enum MembersFilterMode {
  showAll,
  showBlocked,
  showDeleted
}

class MembersRequestParams extends ListRequestParams {

  MembersFilterMode filterMode;

  MembersRequestParams ({
    this.filterMode,
    search,
    offset = 0,
    limit = 50,
    orderType
  }) : super(
    search: search,
    offset: offset,
    limit: limit,
    orderType: orderType
  );

  Map<String, String> get queryMap {
    Map<String, String> queryMap = super.queryMap;
    queryMap[Keys().filterMode] = queryParam(EnumUtils.indexOf(filterMode, MembersFilterMode.values));
    return queryMap;
  }

}

abstract class RequestParams {

  String queryParam(dynamic value) {
    if (value is String) {
      return value ?? "";
    } else {
      if (value != null) {
        return value.toString();
      }
    }
    return "";
  }

  String listQueryParam(List values) {
    return values.map((e) => e.toString()).join(
      ","
    );
  }

  Map<String, String> get queryMap;
}

class ListRequestParams extends RequestParams {

  final String search;
  final ListOrder orderType;
  final int limit;
  final int offset;

  final List<int> roleIds;
  final List<String> firebaseUids;

  ListRequestParams ({
    this.search,
    this.offset = 0,
    this.limit = 50,
    this.orderType,
    this.firebaseUids,
    this.roleIds
  });

  bool get hasSearch {
    if (search != null) {
      return search.isNotEmpty;
    }
    return false;
  }

  Map<String, String> get queryMap {
    return {
      Keys().search: queryParam(search),
      Keys().orderType: queryParam(EnumUtils.indexOf(orderType, ListOrder.values)),
      Keys().limit: queryParam(limit),
      Keys().roles: listQueryParam(roleIds),
      Keys().users: listQueryParam(firebaseUids),
      Keys().offset: queryParam(offset)
    };
  }



}

enum HttpMethod {
  post,
  get
}

class Headers {
  static const String idToken = "X-Id-Token";
  static const String contentType = "Content-Type";
  static const String mediaTypeJson = "application/json";
}

class AuthorizationProvider {

  static String dummyToken;

  static Future<String> getIdToken() async {
    if (dummyToken != null) {
      return dummyToken;
    }

    String firebaseToken = await (await FirebaseAuth.instance.currentUser()).getIdToken();
    return firebaseToken;
  }

  static Future<String> getMyUid() async {
    String uuid = (await FirebaseAuth.instance.currentUser()).uid;
    return uuid;
  }



}


class JsonObjectFormatter<T extends ParsableObject> {

  final T Function(Map<String, dynamic>) objectCreator;

  JsonObjectFormatter(this.objectCreator);

  List<T> parseObjects(dynamic jsonResponse) {
    List<T> items = [];
    if (jsonResponse is List) {
      items = parseAsList(jsonResponse);
    } else if (jsonResponse is Map<String, dynamic>) {
      items.add(parseObject(jsonResponse));
    }
    return items;
  }

  List<T> parseAsList(List jsonResponse) {
    List<T> items = [];
    for (Map<String, dynamic> jsonMap in jsonResponse) {
      var newObject = this.objectCreator(jsonMap);
      items.add(newObject);
    }
    return items;
  }

  T parseObject(Map<String, dynamic> response) {
    return this.objectCreator(response);
  }

  toPostData(List<T> objectsToPost, { bool singleObjectFormat = false}) {
    if (singleObjectFormat) {
      T objectToPost = objectsToPost.length > 0 ? objectsToPost.first : null;
      return objectToPost.toDictionary();
    } else {
      var dictList = [];
      for (T object in objectsToPost) {
        dictList.add(
            object.toDictionary()
        );
      }
      return dictList;
    }
  }

}

class RestRequest<T extends ParsableObject> extends Request  {

  final String path;
  final T Function(Map<String, dynamic>) objectCreator;

  JsonObjectFormatter formatter;

  RestRequest (this.path, { this.objectCreator }) {
    formatter = JsonObjectFormatter<T>(objectCreator);
  }


  Future delete() {
    return http.delete(Urls.urlForPath(
      path: path
    ));
  }

  Future<List<T>> postAll(List<T> objectsToPost, { singleObjectFormat = false }) {
    Completer<List<T>> completer = new Completer();
    executeJsonRequest(Urls.urlForPath(
      path: this.path
    ), completer, (http.Response response) {
      List<T> responseObjects = formatter.parseObjects(jsonObjectResponse(response));
      completer.complete(responseObjects);
    }, postDictionary: this.formatter.toPostData(objectsToPost, singleObjectFormat: singleObjectFormat));
    return completer.future;
  }

  Future<T> postSingle(T objectToPost, { singleObjectFormat = true }) {
    Completer<T> completer = new Completer();
    postAll([objectToPost], singleObjectFormat: singleObjectFormat).then((List<T> objects) {
      if (objects.length > 0) {
        completer.complete(objects.first);
      } else {
        completer.complete(null);
      }
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }


  Future<T> getSingle({ DownloadStatusInfo downloadStatusListener }) {
    Completer<T> completer = Completer();
    getAll(
      downloadStatusListener: downloadStatusListener
    ).then((value) {
      if (value.length > 0) {
        completer.complete(value.first);
      } else {
        completer.complete(null);
      }
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }


  Future<List<T>> getAll({ RequestParams params, DownloadStatusInfo downloadStatusListener }) {
    Completer<List<T>> completer = new Completer();
    downloadStatusListener.downloadDidStart();
    String url = Urls.urlForPath(
      path: this.path,
      params: params
    );
    executeJsonRequest(url, completer, (http.Response response) {
      var jsonResponse = jsonObjectResponse(response);
      List<T> items = formatter.parseObjects(jsonResponse);
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

//TODO: Create content_version, content_flag, content_viewer


class ChannelDetailsRequest extends Request {

  final int channelId;

  ChannelRoute route;

  ChannelDetailsRequest (this.channelId) {
    this.route = ChannelRoute(channelId: channelId);
  }

  Future<Member> join() {
    Completer<Member> completer = Completer();
    executeJsonRequest(route.join, completer, (response) {
      var jsonResponse = jsonObjectResponse(response);
      completer.complete(Member(jsonResponse));
    });
    return completer.future;
  }

  Future leave() {
    Completer completer = Completer();
    executeJsonRequest(route.leave, completer, (response) => completer.complete());
    return completer.future;
  }

  Future<String> getCode() {
    Completer<String> completer = Completer();
    executeJsonRequest(route.joinCode, completer, (response) {
      completer.complete(jsonObjectResponse(response));
    });
    return completer.future;
  }

  Future<String> resetCode() {
    Completer<String> completer = Completer();
    executeJsonRequest(route.joinCode, completer, (response) {
      completer.complete(jsonObjectResponse(response));
    }, httpMethod: HttpMethod.post);
    return completer.future;
  }
}

class PublicChannelsRequest extends RestRequest<Channel> {

  PublicChannelsRequest () : super (
    GlobalRoute().publicChannels,
    objectCreator: (Map<String, dynamic> map) {
      return Channel(map);
    }
  );

  @override
  Future<Channel> getSingle({downloadStatusListener}) {
    throw UnimplementedError();
  }

  @override
  Future delete() {
    throw UnimplementedError();
  }

  @override
  Future<List<Channel>> postAll(List<Channel> objectsToPost, {singleObjectFormat = false}) {
    throw UnimplementedError();
  }

  @override
  Future<Channel> postSingle(Channel objectToPost, {singleObjectFormat = true}) {
    throw UnimplementedError();
  }

}

class MyChannelsRequest extends RestRequest<Channel> {

  MyChannelsRequest () : super(
    GlobalRoute().myChannels,
    objectCreator: (Map<String, dynamic> map) {
      return Channel(map);
    }
  );

  @override
  Future<Channel> getSingle({downloadStatusListener}) {
    throw UnimplementedError();
  }

  @override
  Future delete() {
    throw UnimplementedError();
  }

  @override
  Future<List<Channel>> postAll(List<Channel> objectsToPost, {singleObjectFormat = false}) {
    throw UnimplementedError();
  }

}

class ViewersRequest extends RestRequest<ContentViewer> {

  ViewersRequest ( String path ) : super(
    path,
    objectCreator: (Map<String, dynamic> map) {
      return ContentViewer(map);
    }
  );

  @override
  Future delete() {
    throw UnimplementedError();
  }

  @override
  Future<ContentViewer> postSingle(ContentViewer objectToPost, {singleObjectFormat = true}) {
    throw UnimplementedError();
  }

  @override
  Future<List<ContentViewer>> postAll(List<ContentViewer> objectsToPost, {singleObjectFormat = false}) {
    throw UnimplementedError();
  }

  @override
  Future<ContentViewer> getSingle({downloadStatusListener}) {
    throw UnimplementedError();
  }

}

class VersionsRequest extends RestRequest<ContentVersion> {

  VersionsRequest (String path) : super(
    path,
    objectCreator: (Map<String, dynamic> map) {
      return ContentVersion(map);
    }
  );

  @override
  Future delete() {
    throw UnimplementedError();
  }

  @override
  Future getSingle({downloadStatusListener}) {
    throw UnimplementedError();
  }

  @override
  Future postSingle(objectToPost, {singleObjectFormat = true}) {
    throw UnimplementedError();
  }

  @override
  Future<List> postAll(List objectsToPost, {singleObjectFormat = false}) {
    throw UnimplementedError();
  }

}


class FlagsRequest extends RestRequest<ContentFlag> {

  FlagsRequest ( String path ) : super(
    path,
    objectCreator: (Map<String, dynamic> map) {
      return ContentFlag(map);
    }
  );

  @override
  Future<ParsableObject> getSingle({downloadStatusListener}) {
    throw UnimplementedError();
  }

}




class ChannelSubObjectsRequest<T extends ParsableObject> extends RestRequest<T> {

  ChannelSubObjectsRequest (String path, { objectCreator }) : super(
    path,
    objectCreator: objectCreator
  );

  @override
  Future<T> getSingle({downloadStatusListener}) {
    throw UnimplementedError();
  }

  @override
  Future delete() {
    throw UnimplementedError();
  }


}

class MentionsRequest extends ChannelSubObjectsRequest<ParsableObject> {

  MentionsRequest (String path) : super(
    path
  );

  @override
  Future<List<ParsableObject>> getAll({RequestParams params, downloadStatusListener}) {
    Completer<List<ParsableObject>> completer = new Completer();
    downloadStatusListener.downloadDidStart();
    String url = Urls.urlForPath(
        path: this.path,
        params: params
    );
    executeJsonRequest(url, completer, (http.Response response) {
      var jsonObject = jsonObjectResponse(response);
      var membersJsonMaps = jsonObject[Keys().members];
      var rolesJsonMaps = jsonObject[Keys().roles];

      List<ParsableObject> items = [];

      for (Map<String, dynamic> jsonMap in rolesJsonMaps) {
        items.add(Role(jsonMap));
      }

      for (Map<String, dynamic> jsonMap in membersJsonMaps) {
        items.add(Member(jsonMap));
      }



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

  @override
  Future<List<ParsableObject>> postAll(List objectsToPost, {singleObjectFormat = false}) {
    throw UnimplementedError();
  }

}

class MembersRequest extends ChannelSubObjectsRequest<Member> {

  MembersRequest (String path) : super(
    path,
    objectCreator: (Map<String, dynamic> map) {
      return Member(map);
    }
  );

}

class TagsRequest extends ChannelSubObjectsRequest<Tag> {

  TagsRequest (String path) : super(
    path,
    objectCreator: (Map<String, dynamic> map) {
      return Tag(map);
    }
  );

}

class RolesRequest extends ChannelSubObjectsRequest<Role> {

  RolesRequest (String path) : super(
    path,
    objectCreator: (Map<String, dynamic> map) {
      return Role(map);
    }
  );

}

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

class AnswersRequest extends RestRequest<Answer> {



}

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

class FollowSettingsRequest<T extends EventPreferences> extends RestRequest<T> {

  FollowSettingsRequest (String path, { T Function(Map<String, dynamic>) objectCreator }) : super(
    path,
    objectCreator: objectCreator
  );

  @override
  Future<List<T>> getAll({RequestParams params, DownloadStatusInfo downloadStatusListener}) {
    throw UnimplementedError();
  }

  @override
  Future<List<T>> postAll(List<T> objectsToPost, {singleObjectFormat = false}) {
    throw UnimplementedError();
  }

  @override
  Future delete() {
    throw UnimplementedError();
  }

}

class NotificationSettingsRequest extends RestRequest<NotificationSettings> {

  NotificationSettingsRequest (String path) : super(
    path,
    objectCreator: (Map<String, dynamic> map) {
      return NotificationSettings(map);
    }
  );

  @override
  Future<List<NotificationSettings>> getAll({RequestParams params, DownloadStatusInfo downloadStatusListener}) {
    throw UnimplementedError();
  }

  @override
  Future<List<NotificationSettings>> postAll(List<NotificationSettings> objectsToPost, {singleObjectFormat = false}) {
    throw UnimplementedError();
  }

  @override
  Future delete() {
    throw UnimplementedError();
  }

}


class CommentsRequest extends RestRequest<Comment> {

  CommentsRequest (String path) : super(
    path,
    objectCreator: (Map<String, dynamic> map) {
      return Comment(map);
    }
  );

  @override
  Future<Comment> getSingle({downloadStatusListener}) {
    throw UnimplementedError();
  }

  @override
  Future<List<Comment>> postAll(List<Comment> objectsToPost, {singleObjectFormat = false}) {
    throw UnimplementedError();
  }

  @override
  Future delete() {
    throw UnimplementedError();
  }

}



class ProfileRequest extends RestRequest<Profile> {

  ProfileRequest () : super(
    GlobalRoute().profile,
    objectCreator: (Map<String, dynamic> map) {
      return Profile(map);
    }
  );

  @override
  Future<List<Profile>> getAll({RequestParams params, downloadStatusListener}) {
    throw UnimplementedError();
  }

  @override
  Future delete() {
    throw UnimplementedError();
  }


}

class VotesRequest extends RestRequest<VotesInfo> {

  VotesRequest (String path) : super(
    path,
    objectCreator: (Map<String, dynamic> map) {
      return null;
    }
  );

  @override
  Future<List<VotesInfo>> postAll(List<VotesInfo> objectsToPost, {singleObjectFormat = false}) {
    throw UnimplementedError();
  }

  @override
  Future<List<VotesInfo>> getAll({RequestParams params, downloadStatusListener}) {
    throw UnimplementedError();
  }

  @override
  Future<VotesInfo> getSingle({downloadStatusListener}) {
    throw UnimplementedError();
  }

  @override
  Future delete() {
    throw UnimplementedError();
  }

}

class Request {

  void executeJsonRequest(
      String url, Completer completer,
      Function(http.Response response) handleSuccessAction,
      { Map<String, dynamic> postDictionary, HttpMethod httpMethod }
      ) async {

    if (httpMethod == null) {
      httpMethod = postDictionary != null ? HttpMethod.post : HttpMethod.get;
    }

    Map<String, String> headers = {
      Headers.contentType: Headers.mediaTypeJson,
      Headers.idToken: await AuthorizationProvider.getIdToken(),
    };

    var action;
    if (httpMethod == HttpMethod.get) {
      action = http.get(url, headers: headers);
    } else if (httpMethod == HttpMethod.post) {
      action = http.post(url, headers: headers, body: postDictionary != null ? json.encode(postDictionary) : null);
    }

    action.then((http.Response response) {
      if (response != null) {
        if (response.statusCode >= 400) {
          throw InvalidOperationException("HTTP exception");
        }
      }
      handleSuccessAction(response);
    }).catchError((e) {
      completer.completeError(e);
    });
  }

  jsonObjectResponse(http.Response httpResponse) {
    return json.decode(httpResponse.body)[Keys().object];
  }

}

class UploadRequest extends Request {

 Future<Upload> upload({
    @required File file,
    UploadRequestParams uploadRequestParams
  }) async {
    Completer<Upload> completer = Completer();
    Map<String, String> headers = {
      Headers.idToken: await AuthorizationProvider.getIdToken(),
      Headers.contentType: Headers.mediaTypeJson
    };

    List<int> bytes = file.readAsBytesSync();
    String fileName = file.path.split("/").last;
    Uri url = Uri.parse(Urls.urlForPath(
      path: GlobalRoute().upload,
      params: uploadRequestParams
    ));

    http.MultipartRequest multipartRequest = http.MultipartRequest(
        HttpMethod.post.toString(), url
    );
    multipartRequest.headers.addAll(headers);
    multipartRequest.files.add(http.MultipartFile.fromBytes(
      Keys().file,
      bytes,
      filename: fileName,
    ));
    multipartRequest.send().then((http.StreamedResponse response) async {
      http.Response httpResponse = await http.Response.fromStream(response);
      final body = jsonObjectResponse(httpResponse);
      completer.complete(Upload(body));
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

}




class Urls {

  static const String baseUrl = "https://api-server-dot-schoolmi-4c5ac.appspot.com";

  static String urlWithQueryParams(String url, Map<String, String> queryMap) {
    Uri oldUri = Uri.parse(url);
    queryMap.addAll(oldUri.queryParameters);
    queryMap.removeWhere((String key, String value) {
      return value == null || value == "";
    });
    Uri newUri = Uri.https(oldUri.authority, oldUri.path, queryMap);
    return newUri.toString();
  }

  static String urlForPath({ String path, RequestParams params }) {
    String url = "$baseUrl/$path";
    if (params != null) {
        return urlWithQueryParams(url, params.queryMap);
    }
    return url;
  }




}
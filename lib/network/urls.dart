import 'package:flutter/foundation.dart';
import 'package:schoolmi/network/query_info.dart';
import 'package:schoolmi/constants/keys.dart';

class Urls {
  static const String baseUrl = "https://api-server-dot-schoolmi-4c5ac.appspot.com";
  static const String usernameExists = "$baseUrl/username";
  static const String profile = "$baseUrl/profile";
  static const String flagContent = "$baseUrl/flag";
  static const String channels = "$baseUrl/channels";
  static const String clearFlag = "$baseUrl/flag/clear";

  static String urlWithQueryParams(String url, Map<String, String> queryMap) {
    Uri oldUri = Uri.parse(url);
    queryMap.addAll(oldUri.queryParameters);
    queryMap.removeWhere((String key, String value) {
      return value == null || value == "";
    });
    Uri newUri = Uri.https(oldUri.authority, oldUri.path, queryMap);
    return newUri.toString();
  }

  static String urlWithQueryInfo(String url, QueryInfo queryInfo) {
    if (queryInfo != null) {
      url = urlWithQueryParams(url, {
        Keys().search: QueryInfo.queryParam(queryInfo.search),
        Keys().mode: QueryInfo.queryParam(queryInfo.order),
        Keys().filterMode: QueryInfo.queryParam(queryInfo.filter),
        Keys().offset: QueryInfo.queryParam(queryInfo.offset)
      });
    }
    return url;
  }


  static String publicChannels ({QueryInfo queryInfo}) {
    String url = "$baseUrl/channels/public";
    url = urlWithQueryInfo(url, queryInfo);
    return url;
  }


  static String leaveChannel({@required int channelId}) {
    return "$baseUrl/channels/$channelId/leave";
  }

  static String joinChannel({@required int channelId}) {
    return "$baseUrl/channels/$channelId/join";
  }

  static String uploadFile({int maxSize = 1024, String mode = "thumbnail", bool includeMini = true}) {
    String url = "$baseUrl/upload";
    return urlWithQueryParams(url, {
      Keys().mode: QueryInfo.queryParam(mode),
      Keys().width: QueryInfo.queryParam(maxSize),
      Keys().height: QueryInfo.queryParam(maxSize),
      Keys().mini: QueryInfo.queryParam(includeMini)
    });
  }

  static String tags({@required int channelId, QueryInfo queryInfo}) {
    String url = "$baseUrl/channels/$channelId/tags";
    url = urlWithQueryInfo(url, queryInfo);
    return url;
  }

  static String comments({@required int channelId, int questionId, int answerId = 0, QueryInfo queryInfo }) {
    String url = "$baseUrl/channels/$channelId/comments?v=1";
    url = urlWithQueryInfo(url, queryInfo);
    url = urlWithQueryParams(url, {
      Keys().questionId: QueryInfo.queryParam(questionId),
      Keys().answerId: QueryInfo.queryParam(answerId)
    });
    return url;
  }

  static String duplicatedQuestions({ @required int channelId, @required int questionId }) {
    return "$baseUrl/channels/$channelId/questions/$questionId/duplicates";
  }

  static String questionDetails ({ @required int channelId, @required int questionId }) {
    return "$baseUrl/channels/$channelId/questions?question_id=$questionId";
  }

  static String questions ({@required int channelId, QueryInfo queryInfo }) {
    String url = "$baseUrl/channels/$channelId/questions?v=1";
    url = urlWithQueryInfo(url, queryInfo);
    return url;
  }

  static String votes ({@required int channelId}) {
    return "$baseUrl/channels/$channelId/votes";
  }

  static String answers ({@required int channelId, int questionId, QueryInfo queryInfo}) {
    String url = "$baseUrl/channels/$channelId/answers";
    url = urlWithQueryParams(url, {
      Keys().questionId: QueryInfo.queryParam(questionId)
    });
    url = urlWithQueryInfo(url, queryInfo);
    return url;
  }

  static String members ({ @required int channelId, QueryInfo queryInfo }) {
    String url = "$baseUrl/channels/$channelId/members";
    if (queryInfo != null) {
      url = urlWithQueryInfo(url, queryInfo);
    }
    return url;
  }

  static String roles ({@required int channelId, QueryInfo queryInfo}) {
    String url = "$baseUrl/channels/$channelId/members/roles";
    url = urlWithQueryInfo(url, queryInfo);
    return url;
  }

  static String reporters ({@required int channelId, int questionId = 0, int answerId = 0, int commentId = 0}) {
    String url = "$baseUrl/channels/$channelId/reporters";
    url = urlWithQueryParams(url, {
      Keys().questionId: QueryInfo.queryParam(questionId ?? 0),
      Keys().answerId: QueryInfo.queryParam(answerId ?? 0),
      Keys().commentId: QueryInfo.queryParam(commentId ?? 0)
    });
    return url;
  }

  static String questionViewers( { @required int channelId, @required int questionId }) {
    String url = "$baseUrl/channels/$channelId/questions/$questionId/viewers";
    return url;
  }



}